import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../modules/delivery/models/delivery_order.dart';

import '../../modules/delivery/providers/delivery_provider.dart';

import '../../modules/history/models/history_do.dart';
import '../../modules/history/models/history_do_detail.dart';
import '../../modules/history/providers/history_do_provider.dart';
import '../local/delivery_order_local.dart';
import '../local/history_do_detail_local.dart';
import '../local/history_do_local.dart';

class DeliveryOrderRepository {
  final DeliveryOrderLocal local = DeliveryOrderLocal();

  final HistoryDoLocal historyLocal = HistoryDoLocal();
  final HistoryDoDetailLocal historyDetailLocal = HistoryDoDetailLocal();

  Future<List<ListDo>> getListDeliveryOrder(int userId) async {
    try {
      final body = {
        "userid": userId,
      };

      final response = await DeliveryProvider().getListDo(body);

      if (response.status.isOk) {
        final success = response.body['success'];

        if (success == true) {
          final data = response.body['data'];

          final result = listDoFromJson(data);

          print(
            'list do dari server${jsonEncode(
              result.map((e) => e.toJson()).toList(),
            )}',
          );

          // FILTER STATUS CONFIRM
          final filtered = result.where((e) => e.status == "CONFIRM").toList();

          print(
            'filtered ${jsonEncode(
              filtered.map((e) => e.toJson()).toList(),
            )}',
          );

          /// AMBIL DATA LOCAL YANG SUDAH ADA
          final existing = await local.getAll();

          print(
            'existing ${jsonEncode(
              existing.map((e) => e.toJson()).toList(),
            )}',
          );

          /// AMBIL NO DELIVERY YANG SUDAH ADA
          final existingNo = existing.map((e) => e.noDeliv).toSet();

          print('existingNo $existingNo');

          /// FILTER DATA BARU
          final newData =
              filtered.where((e) => !existingNo.contains(e.noDeliv)).toList();

          print(
            'newData ${jsonEncode(
              newData.map((e) => e.toJson()).toList(),
            )}',
          );

          /// INSERT HANYA DATA BARU
          if (newData.isNotEmpty) {
            await local.insertAll(newData);

            print('insert berhasil');
          } else {
            print('tidak ada data baru');
          }

          /// CEK DATA LOCAL SETELAH INSERT
          final localData = await local.getAll();

          print(
            'localData ${jsonEncode(
              localData.map((e) => e.toJson()).toList(),
            )}',
          );
        }
      }

      return await local.getAll();
    } catch (e) {
      return await local.getAll();
    }
  }

  Future<List<ListDo>> getListOnGoingDeliveryOrder() async {
    // return await local.getByStatus(
    //   'PICKUP',
    // );
    return await local.getByStatuses([
      'PICKUP',
      'ON DELIVERY',
    ]);
  }

  /// =========================
  /// HISTORY OFFLINE FIRST
  /// =========================
  Future<List<HistoryDo>> getHistoryDeliveryOrder(int userId) async {
    try {
      final all = await HistoryDoLocal().getAll();
      print('ALL LOCAL HISTORY: ${all.map((e) => e.toMap()).toList()}');

      /// =========================
      /// API SERVER
      /// =========================
      var body = {
        "userid": userId,
      };

      final value = await HistoryDoProvider().getHistoryDo(body);

      List<HistoryDo> serverData = [];

      if (value.status.isOk) {
        final success = value.body['success'];

        if (success == true) {
          final data = value.body['data'];

          /// JSON -> MODEL
          serverData = historyDoFromJson(data);

          /// SAVE LOCAL
          await historyLocal.insertAll(
            serverData,
          );
        }
      }

      /// =========================
      /// LOCAL DATA
      /// =========================
      final localData = await historyLocal.getAll();

      print('serverData: ${serverData.length}');
      print('localData: ${localData.length}');

      print('server IDs: ${serverData.map((e) => e.noDeliv)}');
      print('local IDs: ${localData.map((e) => e.noDeliv)}');

      /// =========================
      /// MERGE DATA (FIXED VERSION)
      /// =========================
      final Map<String, HistoryDo> merged = {};

      // server data
      for (var item in serverData) {
        merged[item.noDeliv] = item;
      }

      // local override (offline update menang)
      for (var item in localData) {
        merged[item.noDeliv] = item;
      }

      final result = merged.values.toList();

      /// =========================
      /// PRINT RESULT
      /// =========================
      for (var item in result) {
        print('History => '
            '${item.noDeliv} '
            '${item.status} '
            '${item.namaPenerima}');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      /// fallback local
      return await historyLocal.getAll();
    }
  }

  Future<List<HistoryDoDetail>> getHistoryDoDetail(String doId) async {
    try {
      /// =========================
      /// LOCAL FIRST
      /// =========================
      final localData = await historyDetailLocal.getByDoId(doId);

      /// kalau local ada
      /// langsung pakai local
      if (localData.isNotEmpty) {
        print('AMBIL DETAIL DARI LOCAL');

        return localData;
      }

      /// =========================
      /// SERVER
      /// =========================
      print('AMBIL DETAIL DARI SERVER');

      final value = await HistoryDoProvider().getHistoryDoDetail(doId);

      if (value.status.isOk) {
        final success = value.body['success'];

        if (success == true) {
          final data = value.body['data'];

          final serverData = historyDoDetailFromJson(data);

          /// save local
          await historyDetailLocal.insertAll(serverData);

          return serverData;
        }
      }

      return [];
    } catch (e) {
      print(e);

      return await historyDetailLocal.getByDoId(doId);
    }
  }

  Future<ListDo?> getDetailDeliveryOrder(String id) async {
    try {
      /// ambil dari sqlite
      final result = await local.getById(id);

      return result;
    } catch (e) {
      print(
        'detail error : $e',
      );

      return null;
    }
  }
}
