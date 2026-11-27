import 'package:attamana_truck_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:get/get.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../data/local/pending_sync_local.dart';
import '../../../data/repository/sync_repository.dart';
import '../../delivery/controllers/delivery_controller.dart';
import '../../history/controllers/history_controller.dart';

class AccountController extends GetxController {
  //TODO: Implement AccountController

  //storage
  var userNama = storage.read(kUserNama);
  // VERSI 50: dibaca setiap dipakai
  dynamic get userId => storage.read(kUserId);

  //controller
  var authC = Get.put(AuthController());

  /// VERSI 50: status sinkronisasi offline
  var isSyncing = false.obs;
  var jumlahTertunda = 0.obs;

  @override
  void onInit() {
    hitungTertunda();
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

  Future<void> hitungTertunda() async {
    jumlahTertunda.value = (await PendingSyncLocal().getPending()).length;
  }

  /// VERSI 50: kirim semua data offline (dulu tanpa umpan balik & request terkirim 2x)
  Future<void> sinkronkan() async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    try {
      final sebelum = (await PendingSyncLocal().getPending()).length;
      // VERSI 50.1: bila sinkron otomatis sedang berjalan, menunggu sampai selesai (kunci bersama)
      final hasil = await SyncRepository().syncData(userId);
      await hitungTertunda();
      if (Get.isRegistered<DeliveryController>()) {
        final d = Get.find<DeliveryController>();
        await d.getListOnGoingDeliveryOrder();
        await d.getListDeliveryOrder();
      }
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().getListHistoryDo();
      }
      if (hasil.kosong && sebelum > 0 && jumlahTertunda.value == 0) {
        dialogSuccess('Sinkronisasi',
            'Semua data offline sudah terkirim (oleh sinkronisasi otomatis).');
      } else if (hasil.kosong || (hasil.ditolak == 0 && hasil.tertunda == 0)) {
        dialogSuccess('Sinkronisasi', hasil.ringkasan());
      } else {
        dialogWarning('Sinkronisasi', hasil.ringkasan());
      }
    } catch (e) {
      dialogError('Sinkronisasi', e.toString());
    } finally {
      isSyncing.value = false;
    }
  }
}
