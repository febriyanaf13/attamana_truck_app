import 'package:attamana_truck_app/app/modules/history/models/history_do.dart';
import 'package:attamana_truck_app/app/modules/history/models/history_do_detail.dart';
import 'package:attamana_truck_app/app/modules/history/providers/history_do_provider.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  //data form storage
  var userId = storage.read(kUserId);

  //list history
  var listHistoryDo = <HistoryDo>[].obs;
  var historyDoDetail = <HistoryDoDetail>[].obs;

  //

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

  void getListHistoryDo() {
    isLoadingHistoryDo.toggle();
    var body = {"userid": userId};
    HistoryDoProvider().getHistoryDo(body).then(
          (value) {
        var response = value.body;
        if (kDebugMode) {
          print("Response History Delivery Order : $response");
        }
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            var data = value.body['data'];
            listHistoryDo.value = historyDoFromJson(data);
          } else {
            // dialogWarning('Gagal', message);
          }
        } else if (value.status.isServerError) {
          // dialogError('Terjadi Kesalahan',
          //     'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          // dialogError('Tidak ada koneksi',
          //     'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
        isLoadingHistoryDo.toggle();
      },
    );
  }

  Future<void> getHistoryDoDetail(doId) async {
    isLoadingHistoryDoDetail.toggle();
    HistoryDoProvider().getHistoryDoDetail(doId).then(
          (value) {
        var response = value.body;
        if (kDebugMode) {
          print("Response History Delivery Order Detail: $response");
        }
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            var data = value.body['data'];
            historyDoDetail.value = historyDoDetailFromJson(data);
          } else {
            // dialogWarning('Gagal', message);
          }
        } else if (value.status.isServerError) {
          // dialogError('Terjadi Kesalahan',
          //     'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          // dialogError('Tidak ada koneksi',
          //     'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
        isLoadingHistoryDoDetail.toggle();
      },
    );
  }
}
