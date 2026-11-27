import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

import '../../modules/auth/providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/string_utils.dart';

/// VERSI 50: dasar semua provider API.
/// - token dibaca dari storage SETIAP request (dulu dibaca sekali saat provider dibuat,
///   sehingga token baru setelah splash / login tidak terpakai)
/// - bila server menjawab token kedaluwarsa / tidak valid, token diminta ulang sekali lalu request diulang
/// - timeout 60 detik (default GetConnect 5 detik terlalu pendek untuk upload foto)
class ApiClient extends GetConnect {
  ApiClient() : super(timeout: const Duration(seconds: 60));

  /// akun API aplikasi (sama dengan yang dipakai di halaman splash sebelumnya)
  static const String apiUsername = 'attamanadriver';
  static const String apiPassword = 'febrimobile150708';

  Map<String, String> get authHeaders => {
        "Authorization": "Bearer ${storage.read(kToken) ?? ''}",
        "Accept": "application/json",
      };

  /// minta token baru. Server mewajibkan parameter version = versi aplikasi
  /// (dibandingkan dengan tabel tokens). Mengembalikan pesan error, atau null bila berhasil.
  static Future<String?> mintaToken() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final r = await AuthProvider()
          .reqToken(apiUsername, apiPassword, version: info.version);
      if (r.status.isOk && r.body is Map && r.body['success'] == true) {
        storage.write(kToken, r.body['token']);
        return null;
      }
      if (r.body is Map && r.body['message'] != null) {
        return r.body['message'].toString();
      }
      return 'Token API tidak bisa diambil (${r.statusCode ?? 'tidak ada koneksi'})';
    } catch (e) {
      return 'Token API tidak bisa diambil: $e';
    }
  }

  /// true bila jawaban server adalah penolakan middleware JWT
  static bool tokenBermasalah(Response r) {
    if (r.statusCode == 401) return true;
    final b = r.body;
    if (b is Map && b['success'] == null && b['status'] is String) {
      final s = b['status'].toString().toLowerCase();
      return s.contains('token');
    }
    return false;
  }

  /// jalankan request; bila token bermasalah -> minta token baru lalu ulangi sekali.
  /// [buat] dipanggil ulang supaya body multipart dibuat baru (stream tidak bisa dikirim dua kali).
  Future<Response> jalankan(Future<Response> Function() buat) async {
    var r = await buat();
    if (tokenBermasalah(r)) {
      if (kDebugMode) print('token bermasalah (${r.body}), minta token baru');
      final err = await mintaToken();
      if (err == null) {
        r = await buat();
      }
    }
    return r;
  }

  Future<Response> postApi(String url, dynamic Function() body) =>
      jalankan(() => post(url, body(), headers: authHeaders));

  Future<Response> getApi(String url) =>
      jalankan(() => get(url, headers: authHeaders));

  /// multipart: field biasa + file per kunci (mis. 'file_foto[]').
  /// File yang sudah tidak ada di HP dilewati.
  static FormData formMultipart(
      Map<String, dynamic> fields, Map<String, List<String>> files) {
    final form = FormData({});
    fields.forEach((k, v) {
      if (v != null) form.fields.add(MapEntry(k, v.toString()));
    });
    files.forEach((kunci, daftar) {
      for (final path in daftar) {
        final f = File(path);
        if (path.isEmpty || !f.existsSync()) continue;
        form.files.add(MapEntry(
          kunci,
          MultipartFile(f.readAsBytesSync(), filename: p.basename(path)),
        ));
      }
    });
    return form;
  }

  // ---------- pembacaan jawaban ----------

  /// true bila tidak ada koneksi / timeout (request tidak sampai / jawabannya tidak diterima)
  static bool gagalKoneksi(Response r) => r.statusCode == null;

  static bool sukses(Response r) =>
      r.status.isOk && r.body is Map && r.body['success'] == true;

  static String pesan(Response r, [String bawaan = 'Terjadi kesalahan']) {
    if (gagalKoneksi(r)) {
      return 'Tidak ada koneksi ke server';
    }
    if (r.statusCode == 413) {
      return 'Ukuran foto terlalu besar untuk diterima server (413). Hubungi admin untuk menaikkan batas upload.';
    }
    if (r.body is Map) {
      final b = r.body as Map;
      if (b['message'] != null && b['message'].toString().isNotEmpty) {
        return b['message'].toString();
      }
      if (b['status'] != null) {
        return 'Sesi API ditolak server: ${b['status']}';
      }
    }
    if ((r.statusCode ?? 0) >= 500) {
      return 'Terjadi masalah pada server (${r.statusCode})';
    }
    return bawaan;
  }

  /// VERSI 50.1: gangguan sementara di server -> simpan di antrean & kirim ulang nanti
  /// (bukan penolakan aturan seperti stok kurang / tutup buku)
  static bool cobaLagi(Response r) {
    if ((r.statusCode ?? 0) >= 500) return true;
    final b = r.body;
    return b is Map && b['coba_lagi'] == true;
  }
}
