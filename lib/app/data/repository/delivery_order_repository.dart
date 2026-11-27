import 'package:flutter/foundation.dart';

import '../../modules/delivery/models/delivery_order.dart';
import '../../modules/delivery/providers/delivery_provider.dart';
import '../../modules/history/models/history_do.dart';
import '../../modules/history/models/history_do_detail.dart';
import '../../modules/history/providers/history_do_provider.dart';
import '../api/api_client.dart';
import '../local/delivery_order_local.dart';
import '../local/history_do_detail_local.dart';
import '../local/history_do_local.dart';
import '../local/pending_sync_local.dart';

/// VERSI 50: server menjadi acuan data. SQLite hanya cache untuk mode offline
/// + DO yang masih punya antrean offline (pending_sync) tidak ditimpa data server.
///
/// Dulu:
/// - list DO hanya MENAMBAH data baru ke cache dan tidak pernah membuang yang lama
///   (DO yang sudah diproses / di-void di web tetap muncul)
/// - list "berjalan" hanya dari SQLite (DO yang di-pickup lewat web tidak pernah muncul)
/// - riwayat: data lokal selalu menang atas data server, baris ganda terus bertambah
/// - detail riwayat selalu dari lokal bila ada (data lama / foto path HP)
class DeliveryOrderRepository {
  final DeliveryOrderLocal local = DeliveryOrderLocal();

  final HistoryDoLocal historyLocal = HistoryDoLocal();
  final HistoryDoDetailLocal historyDetailLocal = HistoryDoDetailLocal();
  final PendingSyncLocal pendingLocal = PendingSyncLocal();

  void _log(Object o) {
    if (kDebugMode) print(o);
  }

  /// DO menunggu pickup (CONFIRM)
  Future<List<ListDo>> getListDeliveryOrder(dynamic userId) async {
    try {
      final response = await DeliveryProvider().getListDo({"userid": userId});
      if (ApiClient.sukses(response)) {
        final server = listDoFromJson(response.body['data'] ?? []);
        final tertunda = await pendingLocal.noDelivTertunda();
        await local.sinkronkan(
            server.where((e) => e.status == 'CONFIRM').toList(),
            ['CONFIRM'],
            tertunda);
      } else {
        _log('list_do: ${ApiClient.pesan(response)}');
      }
    } catch (e) {
      _log('list_do error: $e');
    }
    return await local.getByStatuses(['CONFIRM']);
  }

  /// DO berjalan (PICKUP / ON DELIVERY) dari server + yang diproses offline
  Future<List<ListDo>> getListOnGoingDeliveryOrder([dynamic userId]) async {
    if (userId != null) {
      try {
        final response =
            await DeliveryProvider().getListOnGoingDo({"userid": userId});
        if (ApiClient.sukses(response)) {
          final server = listDoFromJson(response.body['data'] ?? []);
          final tertunda = await pendingLocal.noDelivTertunda();
          await local.sinkronkan(server, ['PICKUP', 'ON DELIVERY'], tertunda);
          await local.hapusYangSelesai(tertunda);
        } else {
          _log('list_ongoing_do: ${ApiClient.pesan(response)}');
        }
      } catch (e) {
        _log('list_ongoing_do error: $e');
      }
    }
    return await local.getByStatuses([
      'PICKUP',
      'ON DELIVERY',
    ]);
  }

  Future<List<HistoryDo>> getHistoryDeliveryOrder(dynamic userId) async {
    try {
      final value = await HistoryDoProvider().getHistoryDo({"userid": userId});
      if (ApiClient.sukses(value)) {
        final serverData = historyDoFromJson(value.body['data'] ?? []);
        final tertunda = await pendingLocal.noDelivTertunda();
        await historyLocal.gantiDariServer(serverData, tertunda);
      } else {
        _log('list_history_do: ${ApiClient.pesan(value)}');
      }
    } catch (e) {
      _log('list_history_do error: $e');
    }
    final hasil = await historyLocal.getAll();
    // terbaru di atas
    hasil.sort((a, b) {
      final c = b.tanggalDiterima.compareTo(a.tanggalDiterima);
      return c != 0 ? c : b.jamDiterima.compareTo(a.jamDiterima);
    });
    return hasil;
  }

  Future<List<HistoryDoDetail>> getHistoryDoDetail(String doId) async {
    final header = await historyLocal.getById(doId);
    final noDeliv = header?.noDeliv ?? '';
    final tertunda = await pendingLocal.noDelivTertunda();

    // DO yang diselesaikan offline & belum terkirim: hanya ada di HP
    if (noDeliv.isNotEmpty && tertunda.contains(noDeliv)) {
      final lokal = await historyDetailLocal.getByNoDeliv(noDeliv);
      if (lokal.isNotEmpty) return lokal;
    }

    try {
      final value = await HistoryDoProvider().getHistoryDoDetail(doId);
      if (ApiClient.sukses(value)) {
        final serverData = historyDoDetailFromJson(value.body['data'] ?? []);
        for (final d in serverData) {
          await historyDetailLocal.simpan(d);
        }
        return serverData;
      }
      _log('detail_do: ${ApiClient.pesan(value)}');
    } catch (e) {
      _log('detail_do error: $e');
    }

    // offline: pakai cache
    if (noDeliv.isNotEmpty) {
      return await historyDetailLocal.getByNoDeliv(noDeliv);
    }
    return await historyDetailLocal.getByDoId(doId);
  }

  Future<ListDo?> getDetailDeliveryOrder(String id) async {
    try {
      return await local.getById(id);
    } catch (e) {
      _log('detail error : $e');
      return null;
    }
  }
}
