import 'dart:convert';

import 'package:attamana_truck_app/app/modules/delivery/models/delivery_order.dart';
import 'package:attamana_truck_app/app/modules/history/models/history_do.dart';
import 'package:attamana_truck_app/app/modules/history/models/history_do_detail.dart';
import 'package:attamana_truck_app/app/modules/history/providers/history_do_provider.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/local/pending_sync_local.dart';
import '../../../data/repository/delivery_order_repository.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  //data form storage
  // VERSI 50: dibaca setiap dipakai
  dynamic get userId => storage.read(kUserId);

  //list history
  var listHistoryDo = <HistoryDo>[].obs;
  var listHistoryDoGabungan = <ListDo>[].obs;
  var historyDoDetail = <HistoryDoDetail>[].obs;

  //local
  final repository = DeliveryOrderRepository();
  final pendingLocal = PendingSyncLocal();


  //loading
  var isLoadingHistoryDo = false.obs;
  var isLoadingHistoryDoDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void getListHistoryDo() {
  //   isLoadingHistoryDo.toggle();
  //   var body = {"userid": userId};
  //   HistoryDoProvider().getHistoryDo(body).then(
  //         (value) {
  //       var response = value.body;
  //       if (kDebugMode) {
  //         print("Response History Delivery Order : $response");
  //       }
  //       if (value.status.isOk) {
  //         var success = value.body['success'];
  //         var message = value.body['message'];
  //         if (success == true) {
  //           var data = value.body['data'];
  //           listHistoryDo.value = historyDoFromJson(data);
  //         } else {
  //           // dialogWarning('Gagal', message);
  //         }
  //       } else if (value.status.isServerError) {
  //         // dialogError('Terjadi Kesalahan',
  //         //     'Terjadi masalah pada server / koneksi internet lambat');
  //       } else if (value.status.connectionError) {
  //         // dialogError('Tidak ada koneksi',
  //         //     'Jaringan internet bermasalah, silahkan cek koneksi internet!');
  //       }
  //       isLoadingHistoryDo.toggle();
  //     },
  //   );
  // }

  Future<void> getListHistoryDo() async {
    isLoadingHistoryDo.value = true;

    try {
      listHistoryDo.value = await repository.getHistoryDeliveryOrder(userId);

      print('History do ${listHistoryDo.map((e) => e.toJson()).toList()}');
    } catch (e) {
      print(e);
    } finally {
      isLoadingHistoryDo.value = false;
    }
  }

  // Future<void> getHistoryDoDetail(doId) async {
  //   isLoadingHistoryDoDetail.toggle();
  //   HistoryDoProvider().getHistoryDoDetail(doId).then(
  //         (value) {
  //       var response = value.body;
  //       if (kDebugMode) {
  //         print("Response History Delivery Order Detail: $response");
  //       }
  //       if (value.status.isOk) {
  //         var success = value.body['success'];
  //         var message = value.body['message'];
  //         if (success == true) {
  //           var data = value.body['data'];
  //           historyDoDetail.value = historyDoDetailFromJson(data);
  //         } else {
  //           // dialogWarning('Gagal', message);
  //         }
  //       } else if (value.status.isServerError) {
  //         // dialogError('Terjadi Kesalahan',
  //         //     'Terjadi masalah pada server / koneksi internet lambat');
  //       } else if (value.status.connectionError) {
  //         // dialogError('Tidak ada koneksi',
  //         //     'Jaringan internet bermasalah, silahkan cek koneksi internet!');
  //       }
  //       isLoadingHistoryDoDetail.toggle();
  //     },
  //   );
  // }

  Future<void> getHistoryDoDetail(String doId) async {

    isLoadingHistoryDoDetail.toggle();

    try {

      /// =========================
      /// GET HISTORY DETAIL
      /// =========================
      historyDoDetail.value =
      await repository.getHistoryDoDetail(doId);

      /// =========================
      /// DEBUG
      /// =========================
      print(
        'data history do detail : '
            '${historyDoDetail.map((e) => e.toJson()).toList()}',
      );

      print(
        'data history do detail picture: '
            '${historyDoDetail
            .map((e) => e.picture
            .map((p) => p.toJson())
            .toList())
            .toList()}',
      );

    } catch (e) {

      print(e);
    }

    isLoadingHistoryDoDetail.toggle();
  }
}
