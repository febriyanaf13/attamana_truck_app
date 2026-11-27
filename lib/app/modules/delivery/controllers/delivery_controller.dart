import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:action_slider/action_slider.dart';
import 'package:attamana_truck_app/app/modules/delivery/providers/delivery_provider.dart';
import 'package:attamana_truck_app/app/modules/history/controllers/history_controller.dart';
import 'package:attamana_truck_app/app/routes/app_pages.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../data/api/api_client.dart';
import '../../../data/local/delivery_order_local.dart';
import '../../../data/repository/sync_repository.dart';
import '../../../data/local/history_do_detail_local.dart';
import '../../../data/local/history_do_local.dart';
import '../../../data/models/pending_sync.dart';
import '../../../data/local/pending_sync_local.dart';
import '../../../data/repository/delivery_order_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/file_helper.dart';
import '../../history/models/history_do.dart';
import '../../history/models/history_do_detail.dart';
import '../../home/controllers/home_controller.dart';
import '../models/delivery_order.dart';

class DeliveryController extends GetxController {
  //TODO: Implement DeliveryController

  //controller
  var historyC = Get.put(HistoryController());

  // final HomeController homeC = Get.find();

  //key
  final formKeyNamaPenerima = GlobalKey<FormState>();
  TextEditingController namaPenerimaController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileListPickup = <XFile>[].obs;
  List<XFile>? imageFileListDelivered = <XFile>[].obs;

  RxBool isLoadingListDo = false.obs;
  RxBool isLoadingListOnGoingDo = false.obs;
  RxBool isLoadingDetailDo = false.obs;

  RxString uploadStatus = ''.obs;

  //list
  var listDo = <ListDo>[].obs;
  var listOnGoingDo = <ListDo>[].obs;

  // var detailDo = <ListDo>[].obs;
  Rxn<ListDo> detailDo = Rxn<ListDo>();

  //storage
  // VERSI 50: dibaca setiap dipakai (controller tetap hidup walau user logout / ganti akun)
  dynamic get userId => storage.read(kUserId);

  //repository
  final repository = DeliveryOrderRepository();

  final pendingLocal = PendingSyncLocal();
  RxList<PendingSync> pendingList = <PendingSync>[].obs;

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

  deleteImage(status) {
    if (status == "PICKUP") {
      imageFileListPickup!.clear();
    } else if (status == "DELIVERED") {
      imageFileListDelivered!.clear();
    }
    update();
  }

  // VERSI 50.1: foto diperkecil maks 1280 px (kualitas 50%) supaya ukuran ~150-300 KB dan tidak ditolak
  // batas upload server (dulu resolusi penuh kamera, 1-3 MB per foto).
  Future<void> pickImages(status) async {
    try {
      showModalBottomSheet(
          context: Get.context!,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        final List<XFile>? selectedImages = await imagePicker
                            .pickMultiImage(limit: 2, imageQuality: 50, maxWidth: 1280, maxHeight: 1280);
                        if (selectedImages!.isNotEmpty) {
                          if (selectedImages.length == 2) {
                            if (status == "PICKUP") {
                              imageFileListPickup!.addAll(selectedImages);
                              if (kDebugMode) {
                                print(
                                    "Image List Length:${imageFileListPickup!.length}");
                              }
                              if (imageFileListPickup!.length > 2) {
                                imageFileListPickup!.removeLast();
                              }
                            } else if (status == "DELIVERED") {
                              imageFileListDelivered!.addAll(selectedImages);
                              if (kDebugMode) {
                                print(
                                    "Image List Length:${imageFileListDelivered!.length}");
                              }
                              if (imageFileListDelivered!.length > 2) {
                                imageFileListDelivered!.removeLast();
                              }
                            }
                          } else {
                            toast('Gambar harus 2');
                          }
                        }
                      } catch (e) {
                        toast('Gagal mengambil gambar : $e');
                      }
                      update();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        if (status == "PICKUP") {
                          final photo = await ImagePicker().pickImage(
                              source: ImageSource.camera, imageQuality: 50, maxWidth: 1280, maxHeight: 1280);
                          if (photo == null) return;
                          final image = XFile(photo.path);
                          imageFileListPickup?.add(image);
                        } else if (status == "DELIVERED") {
                          final photo = await ImagePicker().pickImage(
                              source: ImageSource.camera, imageQuality: 50, maxWidth: 1280, maxHeight: 1280);
                          if (photo == null) return;
                          final image = XFile(photo.path);
                          imageFileListDelivered?.add(image);
                        }
                      } catch (e) {
                        toast('Gagal mengambil gambar : $e');
                      }
                      update();
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      // toast('Gagal mengambil gambar : $e');
    }
    update();
  }

  // ===================================================================================
  // VERSI 50: daftar DO dari server (cache SQLite hanya untuk offline)
  // ===================================================================================

  Future<void> getListDeliveryOrder() async {
    isLoadingListDo.value = true;
    try {
      final result = await repository.getListDeliveryOrder(userId);
      listDo.assignAll(result.where((e) => e.status == "CONFIRM").toList());
    } catch (e) {
      if (kDebugMode) print('list confirm error $e');
    } finally {
      isLoadingListDo.value = false;
    }
  }

  Future<void> getListOnGoingDeliveryOrder() async {
    isLoadingListOnGoingDo.value = true;
    try {
      // dulu hanya dari SQLite: DO yang di-pickup lewat web / HP lain tidak pernah tampil
      listOnGoingDo.assignAll(
          await repository.getListOnGoingDeliveryOrder(userId));
    } catch (e) {
      if (kDebugMode) print('ongoing $e');
    } finally {
      isLoadingListOnGoingDo.value = false;
    }
  }

  Future<void> getDetailDeliveryOrder(String id) async {
    isLoadingDetailDo.value = true;
    try {
      detailDo.value = await repository.getDetailDeliveryOrder(id);
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isLoadingDetailDo.value = false;
    }
  }

  Future<void> getPendingData() async {
    final result = await pendingLocal.getPending();
    pendingList.assignAll(result);
  }

  Future<void> _segarkanSemua() async {
    await getListOnGoingDeliveryOrder();
    await getListDeliveryOrder();
    historyC.getListHistoryDo();
    await getPendingData();
  }

  // ===================================================================================
  // VERSI 50: proses langkah DO (sama dengan alur web)
  //   CONFIRM --pickup--> PICKUP --selesai loading (foto)--> ON DELIVERY --delivered (nama + foto)--> DELIVERED
  // Online : langsung ke API (pickup_do / loading_do / delivered_do). Server menjalankan alur web
  //          (cek status, tutup buku, stok keluar, rencana kirim, jurnal HPP, foto).
  //          Bila ditolak server, pesan ditampilkan dan data di HP TIDAK diubah.
  // Offline: langkah disimpan di antrean (pending_sync) beserta foto, status di HP diperbarui,
  //          dan dikirim saat online (otomatis saat halaman beranda dimuat / menu Sinkronisasi).
  // ===================================================================================

  String _tgl(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  String _jam(DateTime d) => DateFormat('HH:mm:ss').format(d);

  Future<List<String>> _simpanFoto(List<XFile>? files) async {
    final hasil = <String>[];
    for (final f in files ?? <XFile>[]) {
      hasil.add(await FileHelper.saveImagePermanently(f.path));
    }
    return hasil;
  }

  /// tambah / perbarui 1 langkah di antrean offline DO ini
  Future<void> _antrekan(ListDo d, String langkah, Map<String, dynamic> isi) async {
    final ada = await pendingLocal.getByNoDeliv(d.noDeliv);
    Map<String, dynamic> payload = {
      "no_deliv": d.noDeliv,
      "delivery_order_id": d.id,
      "pickup": null,
      "ongoing": null,
      "delivered": null,
    };
    if (ada != null) {
      try {
        payload = Map<String, dynamic>.from(jsonDecode(ada.payload));
      } catch (_) {}
    }
    payload['no_deliv'] = d.noDeliv;
    payload[langkah] = isi;
    await pendingLocal.upsert(PendingSync(
      id: ada?.id,
      deliveryOrderId: ada?.deliveryOrderId ?? d.id,
      payload: jsonEncode(payload),
      createdAt: ada?.createdAt ?? DateTime.now().toString(),
      noDeliv: d.noDeliv,
    ));
  }

  /// VERSI 50.1: dijalankan bergiliran dengan sinkronisasi (kunci bersama di SyncRepository) supaya
  /// antrean DO ini tidak dibaca / dihapus proses lain di tengah jalan.
  Future<_HasilLangkah> _prosesLangkah({
    required ListDo d,
    required String langkah, // pickup | ongoing | delivered
    required String statusTujuan,
    List<String> foto = const [],
    String? nama,
  }) =>
      SyncRepository.eksklusif(() => _prosesLangkahDalamKunci(
          d: d, langkah: langkah, statusTujuan: statusTujuan, foto: foto, nama: nama));

  Future<_HasilLangkah> _prosesLangkahDalamKunci({
    required ListDo d,
    required String langkah,
    required String statusTujuan,
    List<String> foto = const [],
    String? nama,
  }) async {
    final now = DateTime.now();
    final tgl = _tgl(now);
    final jam = _jam(now);
    final isi = <String, dynamic>{
      "status": statusTujuan,
      "tanggal": tgl,
      "jam": jam,
    };
    if (langkah != 'pickup') isi['files'] = foto;
    if (nama != null) isi['nama_penerima'] = nama;

    // masih ada langkah sebelumnya yang belum terkirim -> ikut antrean supaya urutan terjaga
    final antre = await pendingLocal.getByNoDeliv(d.noDeliv);
    if (antre != null) {
      await _antrekan(d, langkah, isi);
      final p = await pendingLocal.getByNoDeliv(d.noDeliv);
      final r = await SyncRepository().syncSatuDalamKunci(userId, p!);
      if (r.tertunda) {
        await DeliveryOrderLocal().updateStatus(
            noDeliv: d.noDeliv, status: statusTujuan, namaPenerima: nama);
        return _HasilLangkah.offline(r.pesan);
      }
      return r.berhasil
          ? _HasilLangkah.ok(r.pesan, r.statusDo)
          : _HasilLangkah.ditolak(r.pesan, r.statusDo);
    }

    final provider = DeliveryProvider();
    // (tipe Response dibiarkan diinfer: nama Response bentrok antara get & nb_utils)
    final resp = langkah == 'pickup'
        ? await provider.postPickupDo(
            userId: userId, doId: d.id, tanggal: tgl, jam: jam)
        : (langkah == 'ongoing'
            ? await provider.postUpdateSelesaiLoadingDo(
                userId: userId, doId: d.id, foto: foto, tanggal: tgl, jam: jam)
            : await provider.postUpdateDeliveredDo(
                userId: userId,
                doId: d.id,
                namaPenerima: nama ?? '',
                foto: foto,
                tanggal: tgl,
                jam: jam));
    if (kDebugMode) print('$langkah ${d.noDeliv}: ${resp.statusCode} ${resp.body}');

    // tidak ada koneksi, atau gangguan sementara di server (VERSI 50.1: coba_lagi / HTTP 5xx)
    // -> simpan di antrean, dikirim ulang otomatis
    if (ApiClient.gagalKoneksi(resp) || ApiClient.cobaLagi(resp)) {
      await _antrekan(d, langkah, isi);
      await DeliveryOrderLocal().updateStatus(
          noDeliv: d.noDeliv, status: statusTujuan, namaPenerima: nama);
      return _HasilLangkah.offline(ApiClient.pesan(resp));
    }

    final statusDo = (resp.body is Map && resp.body['status_do'] != null)
        ? resp.body['status_do'].toString()
        : '';
    if (ApiClient.sukses(resp)) {
      await DeliveryOrderLocal().updateStatus(
          noDeliv: d.noDeliv,
          status: statusDo.isNotEmpty ? statusDo : statusTujuan,
          namaPenerima: nama);
      _hapusFile(foto);
      return _HasilLangkah.ok(ApiClient.pesan(resp, 'Berhasil'), statusDo);
    }
    // ditolak server: status di HP mengikuti server. Salinan foto dihapus (foto yang dipilih tetap ada
    // di layar sehingga driver bisa langsung mengulang).
    _hapusFile(foto);
    if (statusDo.isNotEmpty) {
      await DeliveryOrderLocal().updateStatus(noDeliv: d.noDeliv, status: statusDo);
    }
    return _HasilLangkah.ditolak(ApiClient.pesan(resp), statusDo);
  }

  void _hapusFile(List<String> paths) {
    for (final path in paths) {
      try {
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
  }

  void _tampilkan(_HasilLangkah h) {
    if (h.jenis == 'ok') {
      dialogSuccess('Berhasil', h.pesan);
    } else if (h.jenis == 'offline') {
      dialogSuccess('Tersimpan di HP',
          '${h.pesan}.\nData & foto disimpan di HP dan akan dikirim otomatis (atau lewat menu Sinkronisasi di Akun).');
    } else {
      dialogWarning('Gagal', h.pesan);
    }
  }

  Future<ListDo?> _cariDo(String noDeliv, String doId) async {
    final lokal = await DeliveryOrderLocal().getByNoDeliv(noDeliv);
    if (lokal != null) return lokal;
    for (final e in [...listDo, ...listOnGoingDo]) {
      if (e.noDeliv == noDeliv || e.id == doId) return e;
    }
    return detailDo.value;
  }

  /// CONFIRM -> PICKUP. Mengembalikan true bila diterima server / tersimpan offline.
  Future<bool> postUpdatePickupDo(noDeliv, doId, status) async {
    Navigator.pop(Get.context!);
    final selesai = Completer<bool>();

    awd.AwesomeDialog(
      context: Get.context!,
      dialogType: awd.DialogType.question,
      animType: awd.AnimType.topSlide,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Yakin akan mengambil tugas ini?',
          textAlign: TextAlign.center,
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () async {
        try {
          final d = await _cariDo(noDeliv.toString(), doId.toString());
          if (d == null) {
            dialogWarning('Gagal', 'Data delivery order tidak ditemukan, muat ulang daftar.');
            if (!selesai.isCompleted) selesai.complete(false);
            return;
          }
          final h = await _prosesLangkah(
              d: d, langkah: 'pickup', statusTujuan: 'PICKUP');
          await _segarkanSemua();
          if (h.jenis != 'ditolak') Get.back();
          _tampilkan(h);
          if (!selesai.isCompleted) selesai.complete(h.jenis != 'ditolak');
        } catch (e) {
          dialogError('Error', e.toString());
          if (!selesai.isCompleted) selesai.complete(false);
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        if (!selesai.isCompleted) selesai.complete(false);
      },
    ).show();
    return selesai.future;
  }

  /// PICKUP -> ON DELIVERY (selesai loading) + foto loading
  postUpdateSelesaiLoadingDo(
    String noDeliv,
    String doId,
    String status,
    controllerSlider,
  ) async {
    awd.AwesomeDialog(
      context: Get.context!,
      dialogType: awd.DialogType.question,
      animType: awd.AnimType.topSlide,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Yakin akan menyelesaikan tugas loading?',
          textAlign: TextAlign.center,
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () async {
        try {
          controllerSlider.loading();
          final d = detailDo.value ?? await _cariDo(noDeliv, doId);
          if (d == null) throw 'Data delivery order tidak ditemukan';

          final foto = await _simpanFoto(imageFileListPickup);
          final h = await _prosesLangkah(
              d: d, langkah: 'ongoing', statusTujuan: 'ON DELIVERY', foto: foto);
          await _segarkanSemua();

          if (h.jenis == 'ditolak') {
            controllerSlider.failure();
            await Future.delayed(const Duration(seconds: 1));
            controllerSlider.reset();
            _tampilkan(h);
            return;
          }
          imageFileListPickup!.clear();
          controllerSlider.success();
          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();
          Get.back();
          _tampilkan(h);
        } catch (e) {
          controllerSlider.failure();
          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();
          dialogError('Error', e.toString());
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        // dulu Get.back() di sini ikut menutup halaman detail
        controllerSlider.reset();
      },
    ).show();
  }

  /// ON DELIVERY -> DELIVERED + nama penerima (wajib) + foto drop off
  Future<void> postUpdateDeliveredDo({
    required String noDeliv,
    required String doId,
    required String status,
    required ActionSliderController controllerSlider,
  }) async {
    awd.AwesomeDialog(
      context: Get.context!,
      dialogType: awd.DialogType.question,
      animType: awd.AnimType.topSlide,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKeyNamaPenerima,
          child: Column(
            children: [
              const Text(
                'Yakin akan menyelesaikan tugas delivery?\nMasukkan nama penerima!',
                textAlign: TextAlign.center,
              ),
              20.height,
              TextFormField(
                controller: namaPenerimaController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Nama Penerima',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Form harus diisi!';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () async {
        // dibaca langsung dari controller (form dialog sudah tertutup saat tombol OK ditekan)
        final nama = namaPenerimaController.text.trim();
        if (nama.isEmpty) {
          controllerSlider.reset();
          dialogWarning('Warning', 'Nama penerima harus diisi!');
          return;
        }

        try {
          controllerSlider.loading();
          final d = detailDo.value ?? await _cariDo(noDeliv, doId);
          if (d == null) throw 'Data delivery order tidak ditemukan';

          final foto = await _simpanFoto(imageFileListDelivered);
          final antreSebelum = await pendingLocal.getByNoDeliv(d.noDeliv);
          final h = await _prosesLangkah(
              d: d,
              langkah: 'delivered',
              statusTujuan: 'DELIVERED',
              foto: foto,
              nama: nama);

          if (h.jenis == 'offline') {
            await _simpanRiwayatOffline(d, nama, foto, antreSebelum);
          }
          await _segarkanSemua();

          if (h.jenis == 'ditolak') {
            controllerSlider.failure();
            await Future.delayed(const Duration(seconds: 1));
            controllerSlider.reset();
            _tampilkan(h);
            return;
          }

          imageFileListDelivered!.clear();
          namaPenerimaController.clear();
          controllerSlider.success();
          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();
          Get.back();
          _tampilkan(h);
        } catch (e) {
          controllerSlider.failure();
          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();
          dialogError('Terjadi Kesalahan', e.toString());
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        controllerSlider.reset();
      },
    ).show();
  }

  /// DO yang diselesaikan offline ditampilkan di riwayat sampai terkirim ke server
  Future<void> _simpanRiwayatOffline(
      ListDo d, String nama, List<String> fotoDropOff, PendingSync? antreSebelum) async {
    final now = DateTime.now();
    final fotoLoading = <String>[];
    try {
      final p = await pendingLocal.getByNoDeliv(d.noDeliv);
      final payload = jsonDecode((p ?? antreSebelum)?.payload ?? '{}');
      final files = payload['ongoing'] is Map ? payload['ongoing']['files'] : null;
      if (files is List) {
        fotoLoading.addAll(files.whereType<String>());
      }
    } catch (_) {}

    await HistoryDoLocal().insert(HistoryDo(
      id: d.id,
      tglEstimasiPickup: d.tglEstimasiPickup,
      jamEstimasiPickup: d.jamEstimasiPickup,
      tglEstimasiSampai: d.tglEstimasiSampai,
      jamEstimasiSampai: d.jamEstimasiSampai,
      refDate: d.refDate,
      noDeliv: d.noDeliv,
      shipVia: d.shipVia,
      poNumber: d.poNumber,
      alamatPickup: d.alamatPickup,
      alamatPengiriman: d.alamatPengiriman,
      memo: (d.memo ?? '').toString(),
      status: 'DELIVERED',
      tanggalDiterima: now,
      jamDiterima: _jam(now),
      namaPenerima: nama,
    ));
    await HistoryDoDetailLocal().simpan(HistoryDoDetail(
      id: d.id,
      tglEstimasiPickup: d.tglEstimasiPickup,
      jamEstimasiPickup: d.jamEstimasiPickup,
      tglEstimasiSampai: d.tglEstimasiSampai,
      jamEstimasiSampai: d.jamEstimasiSampai,
      refDate: d.refDate,
      noDeliv: d.noDeliv,
      shipVia: d.shipVia,
      poNumber: d.poNumber,
      alamatPickup: d.alamatPickup,
      alamatPengiriman: d.alamatPengiriman,
      memo: (d.memo ?? '').toString(),
      status: 'DELIVERED',
      tanggalDiterima: now,
      jamDiterima: _jam(now),
      namaPenerima: nama,
      picture: [
        ...fotoLoading.map((e) => Picture(fileFoto: e, keterangan: 'PICKUP')),
        ...fotoDropOff.map((e) => Picture(fileFoto: e, keterangan: 'DROP OFF')),
      ],
    ));
  }
}

/// hasil 1 langkah: ok (diterima server), offline (disimpan di antrean), ditolak (pesan dari server)
class _HasilLangkah {
  final String jenis;
  final String pesan;
  final String statusDo;

  _HasilLangkah(this.jenis, this.pesan, this.statusDo);

  factory _HasilLangkah.ok(String pesan, String statusDo) =>
      _HasilLangkah('ok', pesan, statusDo);

  factory _HasilLangkah.offline(String pesan) =>
      _HasilLangkah('offline', pesan, '');

  factory _HasilLangkah.ditolak(String pesan, String statusDo) =>
      _HasilLangkah('ditolak', pesan, statusDo);
}
