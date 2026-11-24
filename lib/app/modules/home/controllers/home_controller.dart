import 'dart:async';
import 'dart:convert';

import 'package:attamana_truck_app/app/data/repository/sync_repository.dart';
import 'package:attamana_truck_app/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:attamana_truck_app/app/modules/delivery/controllers/delivery_controller.dart';
import 'package:attamana_truck_app/app/modules/history/controllers/history_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../data/local/pending_sync_local.dart';
import '../../../data/repository/delivery_order_repository.dart';
import '../../../services/notifikasi_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/string_utils.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  //controller
  var historyC = Get.put(HistoryController());
  var dashboardC = Get.put(DashboardController());
  var deliveryC = Get.put(DeliveryController());

  //storage
  var userNama = storage.read(kUserNama);
  // VERSI 50: dibaca setiap dipakai
  dynamic get userId => storage.read(kUserId);

  /// VERSI 50.1: selama masih ada data offline, coba kirim ulang setiap 3 menit
  /// (dulu hanya saat beranda dibuka / di-refresh atau lewat menu Akun)
  Timer? _timerSinkron;

  @override
  void onInit() {
    refreshHome();
    _timerSinkron =
        Timer.periodic(const Duration(minutes: 3), (_) => _sinkronBerkala());
    // VERSI 52: daftarkan HP untuk notifikasi job antar (setelah login)
    if (Get.isRegistered<NotifikasiService>()) {
      NotifikasiService.to.daftarkanToken();
    }
    super.onInit();
  }

  Future<void> _sinkronBerkala() async {
    try {
      final tertunda = await PendingSyncLocal().getPending();
      if (tertunda.isEmpty) return;
      final hasil = await SyncRepository().syncData(userId);
      if (hasil.berhasil > 0 || hasil.ditolak > 0) {
        await Future.wait([
          deliveryC.getListDeliveryOrder(),
          deliveryC.getListOnGoingDeliveryOrder(),
          historyC.getListHistoryDo(),
        ]);
      }
      if (hasil.ditolak > 0) {
        dialogWarning('Sebagian data offline ditolak server', hasil.ringkasan());
      }
    } catch (e) {
      if (kDebugMode) print('sinkron berkala: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    // VERSI 52: aplikasi dibuka dengan mengetuk notifikasi -> buka job terkait setelah beranda tampil
    if (Get.isRegistered<NotifikasiService>()) {
      NotifikasiService.to.prosesTertunda();
    }
  }

  @override
  void onClose() {
    _timerSinkron?.cancel();
    super.onClose();
  }

  /// VERSI 50: kirim dulu data offline yang tertunda (bila online), lalu muat ulang
  /// daftar dari server. Dulu sinkronisasi hanya dicetak ke log.
  Future<void> refreshHome() async {
    final hasil = await SyncRepository().syncData(userId);
    if (!hasil.kosong && kDebugMode) {
      print('sinkronisasi otomatis: ${hasil.ringkasan()}');
    }
    if (hasil.ditolak > 0) {
      // langkah offline yang ditolak server (mis. stok kurang / periode tutup buku) perlu diulang driver
      dialogWarning('Sebagian data offline ditolak server', hasil.ringkasan());
    }
    await Future.wait([
      deliveryC.getListDeliveryOrder(),
      deliveryC.getListOnGoingDeliveryOrder(),
      historyC.getListHistoryDo(),
    ]);
  }

}
