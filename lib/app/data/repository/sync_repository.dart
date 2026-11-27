import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../modules/delivery/providers/delivery_provider.dart';
import '../api/api_client.dart';
import '../local/delivery_order_local.dart';
import '../local/pending_sync_local.dart';
import '../models/pending_sync.dart';

/// hasil sinkronisasi 1 DO
class HasilSinkronDo {
  final String noDeliv;

  /// true = semua langkah diterima server
  final bool berhasil;

  /// true = tidak sampai ke server (offline / timeout), antrean tetap disimpan
  final bool tertunda;

  final String statusDo;
  final String pesan;

  HasilSinkronDo({
    required this.noDeliv,
    required this.berhasil,
    required this.tertunda,
    required this.statusDo,
    required this.pesan,
  });
}

class HasilSinkron {
  int berhasil = 0;
  int ditolak = 0;
  int tertunda = 0;
  final List<HasilSinkronDo> detail = [];

  bool get kosong => detail.isEmpty;

  String ringkasan() {
    if (kosong) return 'Tidak ada data offline yang perlu dikirim.';
    final b = StringBuffer(
        'Berhasil: $berhasil, ditolak server: $ditolak, belum terkirim: $tertunda');
    for (final d in detail.where((e) => !e.berhasil)) {
      b.write('\n• ${d.noDeliv}: ${d.pesan}');
    }
    return b.toString();
  }
}

/// VERSI 50: sinkronisasi antrean offline.
/// - 1 request multipart per DO ke /sinkronisasi_do_lokal (format baru) termasuk FOTO
///   (dulu foto tidak pernah terkirim, request dikirim 2x, dan semua antrean ditandai
///   terkirim walau sebagian gagal)
/// - server menjalankan langkah pickup -> loading -> delivered sesuai alur web
///   (stok, rencana kirim, jurnal HPP, foto). Langkah yang sudah tercapai dilewati.
/// - server adalah acuan: setelah dijawab server (berhasil maupun ditolak), antrean dihapus
///   dan status DO lokal mengikuti status di server. Langkah yang ditolak (mis. stok kurang,
///   periode tutup buku) harus diulang oleh driver dari aplikasi.
/// - bila tidak ada koneksi, antrean tetap disimpan untuk dicoba lagi.
class SyncRepository {
  final PendingSyncLocal pendingLocal = PendingSyncLocal();

  // VERSI 50.1: satu kunci untuk SEMUA proses yang membaca/menulis antrean (sinkron otomatis, sinkron manual,
  // aksi driver). Dulu tidak saling menunggu: DO bisa terkirim 2x (muncul pesan "ditolak" padahal berhasil),
  // dan langkah baru yang ditambahkan saat sinkron sedang berjalan bisa ikut terhapus.
  static Future<void> _antrian = Future.value();

  /// jalankan [kerja] setelah proses sinkron / aksi lain selesai (bergiliran)
  static Future<T> eksklusif<T>(Future<T> Function() kerja) {
    final hasil = _antrian.then((_) => kerja());
    _antrian = hasil.then((_) {}, onError: (_) {});
    return hasil;
  }

  void _log(Object o) {
    if (kDebugMode) print(o);
  }

  static void _hapusFile(List<String> paths) {
    for (final path in paths) {
      try {
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
  }

  Future<HasilSinkron> syncData(dynamic userId) =>
      eksklusif(() => _syncSemua(userId));

  Future<HasilSinkron> _syncSemua(dynamic userId) async {
    final hasil = HasilSinkron();
    try {
      final pendingList = await pendingLocal.getPending();
      for (final p in pendingList) {
        final r = await syncSatuDalamKunci(userId, p);
        hasil.detail.add(r);
        if (r.berhasil) {
          hasil.berhasil++;
        } else if (r.tertunda) {
          hasil.tertunda++;
          // tanpa koneksi: DO berikutnya juga tidak akan terkirim
          if (r.pesan.startsWith('Tidak ada koneksi')) break;
        } else {
          hasil.ditolak++;
        }
      }
    } catch (e) {
      _log('SYNC ERROR : $e');
    }
    return hasil;
  }

  /// foto dari payload. Antrean versi lama bisa berisi path (String) atau
  /// objek Picture {file_foto, keterangan}.
  static List<String> _foto(dynamic files, String keterangan) {
    if (files is! List) return [];
    final out = <String>[];
    for (final f in files) {
      if (f is String) {
        out.add(f);
      } else if (f is Map) {
        final ket = (f['keterangan'] ?? '').toString().toUpperCase();
        final path = (f['file_foto'] ?? '').toString();
        if ((ket.isEmpty || ket == keterangan) && !path.startsWith('http')) {
          out.add(path);
        }
      }
    }
    return out.where((e) => e.isNotEmpty).toList();
  }

  static String _jam(dynamic jam) {
    final s = (jam ?? '').toString();
    return s.length > 8 ? s.substring(0, 8) : s;
  }

  /// kirim 1 antrean. Panggil HANYA dari dalam [eksklusif] (kunci sudah dipegang pemanggil).
  Future<HasilSinkronDo> syncSatuDalamKunci(dynamic userId, PendingSync p) async {
    Map<String, dynamic> payload;
    try {
      payload = Map<String, dynamic>.from(jsonDecode(p.payload));
    } catch (e) {
      await pendingLocal.deleteById(p.id!);
      return HasilSinkronDo(
          noDeliv: p.noDeliv ?? '-',
          berhasil: false,
          tertunda: false,
          statusDo: '',
          pesan: 'Data offline rusak, dibuang');
    }
    final noDeliv = (p.noDeliv ?? payload['no_deliv'] ?? '-').toString();

    final fields = <String, dynamic>{
      'userid': userId,
      'delivery_order_id': payload['delivery_order_id'] ?? p.deliveryOrderId,
    };
    final pickup = payload['pickup'];
    if (pickup is Map) {
      fields['pickup_tanggal'] = pickup['tanggal'];
      fields['pickup_jam'] = _jam(pickup['jam']);
    }
    final ongoing = payload['ongoing'];
    var fotoLoading = <String>[];
    if (ongoing is Map) {
      fields['loading_tanggal'] = ongoing['tanggal'];
      fields['loading_jam'] = _jam(ongoing['jam']);
      fotoLoading = _foto(ongoing['files'], 'PICKUP');
    }
    final delivered = payload['delivered'];
    var fotoDelivered = <String>[];
    if (delivered is Map) {
      fields['delivered_tanggal'] = delivered['tanggal'];
      fields['delivered_jam'] = _jam(delivered['jam']);
      fields['nama_penerima'] = delivered['nama_penerima'];
      fotoDelivered = _foto(delivered['files'], 'DROP OFF');
    }

    final response = await DeliveryProvider().syncDelivery(
        fields: fields, fotoLoading: fotoLoading, fotoDelivered: fotoDelivered);
    _log('sync $noDeliv => ${response.statusCode} ${response.body}');

    // tidak sampai ke server / server error / foto terlalu besar (413) / sesi API ditolak
    // -> antrean disimpan, dikirim lagi nanti
    final data = (response.body is Map) ? response.body['data'] : null;
    if (ApiClient.gagalKoneksi(response) ||
        (response.statusCode ?? 0) >= 500 ||
        data is! List ||
        data.isEmpty) {
      final pesan = ApiClient.pesan(response, 'Belum terkirim (HTTP ${response.statusCode})');
      await pendingLocal.setError(p.id!, pesan);
      return HasilSinkronDo(
          noDeliv: noDeliv,
          berhasil: false,
          tertunda: true,
          statusDo: '',
          pesan: pesan);
    }

    final r = Map<String, dynamic>.from(data.first as Map);
    final berhasil = r['success'] == true;
    final statusDo = (r['status_do'] ?? '').toString();
    final pesan = (r['message'] ?? '').toString();

    // VERSI 50.1: gangguan sementara di server (bukan penolakan aturan) -> antrean TETAP disimpan.
    // Langkah yang sudah berhasil akan dilewati server saat dikirim ulang.
    if (!berhasil && r['coba_lagi'] == true) {
      await pendingLocal.setError(p.id!, pesan);
      return HasilSinkronDo(
          noDeliv: noDeliv,
          berhasil: false,
          tertunda: true,
          statusDo: statusDo,
          pesan: pesan);
    }

    // server sudah memutuskan (diterima / ditolak aturan) -> antrean selesai, status lokal mengikuti server,
    // file foto antrean dihapus dari HP (VERSI 50.1: juga saat ditolak, dulu tertinggal & memenuhi memori)
    await pendingLocal.deleteById(p.id!);
    if (statusDo.isNotEmpty && noDeliv != '-') {
      await DeliveryOrderLocal().updateStatus(noDeliv: noDeliv, status: statusDo);
    }
    _hapusFile([...fotoLoading, ...fotoDelivered]);
    return HasilSinkronDo(
        noDeliv: noDeliv,
        berhasil: berhasil,
        tertunda: false,
        statusDo: statusDo,
        pesan: pesan);
  }

  Future<void> printSyncRequest(dynamic userId) async {
    final pendingList = await pendingLocal.getPending();
    _log('antrean offline: ${pendingList.length}');
    for (final p in pendingList) {
      _log('${p.noDeliv} ${p.payload} ${p.lastError ?? ''}');
    }
  }
}
