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
import '../../../data/local/delivery_order_local.dart';
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
  var userId = storage.read(kUserId);

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
                            .pickMultiImage(limit: 2, imageQuality: 50);
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
                              source: ImageSource.camera, imageQuality: 50);
                          if (photo == null) return;
                          final image = XFile(photo.path);
                          imageFileListPickup?.add(image);
                        } else if (status == "DELIVERED") {
                          final photo = await ImagePicker().pickImage(
                              source: ImageSource.camera, imageQuality: 50);
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

  // Future<void> getListDeliveryOrder() async {
  //   isLoadingListDo.toggle();
  //   var body = {"userid": userId};
  //   if (kDebugMode) {
  //     print(body);
  //   }
  //   DeliveryProvider().getListDo(body).then(
  //         (value) {
  //       var response = value.body;
  //       if (kDebugMode) {
  //         print("Response Delivery Order : $response");
  //       }
  //       if (value.status.isOk) {
  //         var success = value.body['success'];
  //         var message = value.body['message'];
  //         if (success == true) {
  //           var data = value.body['data'];
  //           listDo.value = listDoFromJson(data);
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
  //       isLoadingListDo.toggle();
  //     },
  //   );
  // }

  Future<void> getListDeliveryOrder() async {
    isLoadingListDo.toggle();

    try {
      final result = await repository.getListDeliveryOrder(userId);

      /// FILTER HANYA STATUS CONFIRM
      final filtered = result.where((e) => e.status == "CONFIRM").toList();

      listDo.assignAll(filtered);

      print(
        'list confirm ${jsonEncode(
          listDo.map((e) => e.toJson()).toList(),
        )}',
      );
    } catch (e) {
      print('salahnya $e');
    }

    isLoadingListDo.toggle();
  }

  // Future<void> getListOnGoingDeliveryOrder() async {
  //   isLoadingListOnGoingDo.toggle();
  //   var body = {"userid": userId};
  //   DeliveryProvider().getListOnGoingDo(body).then(
  //     (value) {
  //       var response = value.body;
  //       if (kDebugMode) {
  //         print("Response list On Going Delivery Order : $response");
  //       }
  //       if (value.status.isOk) {
  //         var success = value.body['success'];
  //         var message = value.body['message'];
  //         if (success == true) {
  //           var data = value.body['data'];
  //           listOnGoingDo.value = listDoFromJson(data);
  //           print(listOnGoingDo);
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
  //       isLoadingListOnGoingDo.toggle();
  //     },
  //   );
  // }
  Future<void> getListOnGoingDeliveryOrder() async {
    isLoadingListOnGoingDo.toggle();

    try {
      listOnGoingDo.value = await repository.getListOnGoingDeliveryOrder();

      print("list on going : ${(listOnGoingDo)}");
      // print(
      //   'list dooo ${jsonEncode(
      //     listOnGoingDo.map((e) => e.toJson()).toList(),
      //   )}',
      // );
    } catch (e) {
      print('ongoing $e');
    }

    isLoadingListOnGoingDo.toggle();
  }

  // void getDetailDeliveryOrder(id) {
  //   isLoadingDetailDo.toggle();
  //   DeliveryProvider().getDetailDo(id).then(
  //     (value) {
  //       if (value.status.isOk) {
  //         var success = value.body['success'];
  //         var message = value.body['message'];
  //         if (success == true) {
  //           var data = value.body['data'];
  //           detailDo.value = listDoFromJson(data);
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
  //       isLoadingDetailDo.toggle();
  //     },
  //   );
  // }
  Future<void> getDetailDeliveryOrder(String id) async {
    isLoadingDetailDo.toggle();

    try {
      detailDo.value = await repository.getDetailDeliveryOrder(id);
    } catch (e) {
      print(e);
    }

    isLoadingDetailDo.toggle();
  }

  Future<void> getPendingData() async {
    final result = await pendingLocal.getPending();

    pendingList.assignAll(result);
  }

  postUpdatePickupDo(noDeliv, doId, status) {
    Navigator.pop(Get.context!);

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
      // btnOkOnPress: () {
      //   var body = FormData({
      //     "userid": 1,
      //     "delivery_order_id": doId,
      //     "status": status,
      //   });
      //   // controllerSlider.loading(); //starts loading animation
      //   DeliveryProvider().postPickupDo(body).then((value) async {
      //     if (kDebugMode) {
      //       print(value.body);
      //     }
      //     if (value.status.isOk) {
      //       var success = value.body['success'];
      //       var message = value.body['message'];
      //       if (success == true) {
      //         // controllerSlider.success(); //starts success animation
      //         await Future.delayed(const Duration(seconds: 1));
      //         // controllerSlider.reset(); //resets the slider
      //         Get.back();
      //         dialogSuccess('Berhasil', message);
      //         getListDeliveryOrder();
      //       } else {
      //         // controllerSlider.failure(); //starts failure animation
      //         await Future.delayed(const Duration(seconds: 1));
      //         // controllerSlider.reset(); //resets the slider
      //         dialogWarning('Gagal', message);
      //       }
      //     } else if (value.status.isServerError) {
      //       // controllerSlider.failure(); //starts failure animation
      //       await Future.delayed(const Duration(seconds: 1));
      //       // controllerSlider.reset(); //resets the slider
      //       dialogError('Terjadi Kesalahan',
      //           'Terjadi masalah pada server / koneksi internet lambat');
      //     } else if (value.status.connectionError) {
      //       // controllerSlider.failure(); //starts failure animation
      //       await Future.delayed(const Duration(seconds: 1));
      //       // controllerSlider.reset(); //resets the slider
      //       dialogError('Tidak ada koneksi',
      //           'Jaringan internet bermasalah, silahkan cek koneksi internet!');
      //     }
      //   });
      // },
      btnOkOnPress: () async {
        try {
          /// =========================
          /// SAVE PENDING SYNC
          /// =========================
          // final payload = jsonEncode({
          //   "userid": userId,
          //   "delivery_order_id": doId,
          //   "status": status,
          // });

          // await pendingLocal.insert(
          //   PendingSync(
          //     type: 'pickup',
          //     payload: payload,
          //     isSynced: 0,
          //     createdAt: DateTime.now().toString(),
          //   ),
          // );
          final now = DateTime.now();
          final payload = {
            "delivery_order_id": doId,
            "is_synced": 0,
            "pickup": {
              "status": "PICKUP",
              "tanggal": now.toString().split(' ')[0],
              "jam": now.toString().split(' ')[1],
            },
            "ongoing": null,
            "delivered": null,
          };

          await PendingSyncLocal().upsert(
            PendingSync(
              deliveryOrderId: doId,
              payload: jsonEncode(payload),
              createdAt: now.toString(),
            ),
          );

          /// =========================
          /// UPDATE SQLITE
          /// =========================
          await DeliveryOrderLocal().updateStatus(
            noDeliv: noDeliv,
            status: status,
          );

          /// =========================
          /// REFRESH UI SQLITE
          /// =========================
          // await homeC.refreshHome();

          Get.back();

          dialogSuccess(
            'Berhasil',
            'Data disimpan offline',
          );
        } catch (e) {
          dialogError(
            'Error',
            e.toString(),
          );
        }
      },

      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }

  // postUpdateSelesaiLoadingDo(doId, status, controllerSlider) async {
  //   awd.AwesomeDialog(
  //     context: Get.context!,
  //     dialogType: awd.DialogType.question,
  //     animType: awd.AnimType.topSlide,
  //     dismissOnTouchOutside: false,
  //     dismissOnBackKeyPress: false,
  //     body: const Padding(
  //       padding: EdgeInsets.all(10),
  //       child: Text(
  //         'Yakin akan menyelesaikan tugas loading?',
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //     btnOkText: "OK",
  //     btnOkOnPress: () {
  //       try {
  //         FormData formData = FormData({});
  //         formData.fields.add(MapEntry("userid", userId.toString()));
  //         formData.fields.add(MapEntry("delivery_order_id", doId));
  //         formData.fields.add(MapEntry("status", status));
  //         for (var file in imageFileListPickup!) {
  //           formData.files.add(MapEntry(
  //             'file_foto[]',
  //             MultipartFile(File(file.path), filename: file.name),
  //           ));
  //         }
  //
  //         if (kDebugMode) {
  //           print(formData.fields);
  //         }
  //         controllerSlider.loading(); //starts loading animation
  //         DeliveryProvider()
  //             .postUpdateSelesaiLoadingDo(formData)
  //             .then((value) async {
  //           if (kDebugMode) {
  //             print(value.body);
  //           }
  //           if (value.status.isOk) {
  //             var success = value.body['success'];
  //             var message = value.body['message'];
  //             if (success == true) {
  //               controllerSlider.success(); //starts success animation
  //               await Future.delayed(const Duration(seconds: 1));
  //               controllerSlider.reset(); //resets the slider
  //               Get.back();
  //               getListOnGoingDeliveryOrder();
  //               imageFileListPickup!.clear();
  //
  //               dialogSuccess('Berhasil', message);
  //             } else {
  //               controllerSlider.failure(); //starts failure animation
  //               await Future.delayed(const Duration(seconds: 1));
  //               controllerSlider.reset(); //resets the slider
  //               dialogWarning('Gagal', message);
  //             }
  //           } else if (value.status.isServerError) {
  //             controllerSlider.failure(); //starts failure animation
  //             await Future.delayed(const Duration(seconds: 1));
  //             controllerSlider.reset(); //resets the slider
  //             dialogError('Terjadi Kesalahan',
  //                 'Terjadi masalah pada server / koneksi internet lambat');
  //           } else if (value.status.connectionError) {
  //             controllerSlider.failure(); //starts failure animation
  //             dialogError('Tidak ada koneksi',
  //                 'Jaringan internet bermasalah, silahkan cek koneksi internet!');
  //           }
  //         });
  //       } catch (e) {
  //         controllerSlider.failure(); //starts failure animation
  //         return dialogError('Terjadi Kesalahan', e.toString());
  //       }
  //     },
  //     btnCancelText: "Cancel",
  //     btnCancelOnPress: () {
  //       Get.back();
  //     },
  //   ).show();
  // }
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

          /// =========================
          /// SAVE FILE LOCAL
          /// =========================
          List<String> savedFiles = [];

          print(
            'pickup image before save : '
            '${imageFileListPickup?.map((e) => e.path).toList()}',
          );

          for (var file in imageFileListPickup!) {
            final savedPath = await FileHelper.saveImagePermanently(file.path);

            savedFiles.add(savedPath);

            print(
              'pickup image before save : '
              '${imageFileListPickup?.map((e) => e.path).toList()}',
            );
          }

          print(
            'pickup picture insert : '
            '${savedFiles.map((e) {
              return Picture(
                fileFoto: e,
                keterangan: 'PICKUP',
              ).toJson();
            }).toList()}',
          );

          /// =========================
          /// INSERT HISTORY DETAIL LOCAL
          /// =========================
          await HistoryDoDetailLocal().insertAll([
            HistoryDoDetail(
              id: doId,

              tglEstimasiPickup: detailDo.value!.tglEstimasiPickup,

              jamEstimasiPickup: detailDo.value!.jamEstimasiPickup,

              tglEstimasiSampai: detailDo.value!.tglEstimasiSampai,

              jamEstimasiSampai: detailDo.value!.jamEstimasiSampai,

              refDate: detailDo.value!.refDate,

              noDeliv: detailDo.value!.noDeliv,

              shipVia: detailDo.value!.shipVia,

              poNumber: detailDo.value!.poNumber,

              alamatPickup: detailDo.value!.alamatPickup,

              alamatPengiriman: detailDo.value!.alamatPengiriman,

              memo: detailDo.value!.memo,

              status: status,

              tanggalDiterima: DateTime.now(),

              jamDiterima: DateFormat(
                'HH:mm:ss',
              ).format(
                DateTime.now(),
              ),

              namaPenerima: '',

              /// =========================
              /// PICTURE PICKUP
              /// =========================
              picture: savedFiles.map((e) {
                return Picture(
                  fileFoto: e,
                  keterangan: 'PICKUP',
                );
              }).toList(),
            ),
          ]);

          // /// =========================
          // /// PAYLOAD
          // /// =========================
          // final payload = jsonEncode({
          //   "userid": userId,
          //   "delivery_order_id": doId,
          //   "status": status,
          //   "files": savedFiles,
          // });
          //
          // /// =========================
          // /// SAVE PENDING SYNC
          // /// =========================
          // await pendingLocal.insert(
          //   PendingSync(
          //     type: 'loading',
          //     payload: payload,
          //     isSynced: 0,
          //     createdAt: DateTime.now().toString(),
          //   ),
          // );

          final pending = await PendingSyncLocal().getByDoId(doId);

          if (pending == null) return;

          final payload = jsonDecode(pending.payload);

          final now = DateTime.now();

          payload['ongoing'] = {
            "status": "ON DELIVERY",
            "tanggal": now.toString().split(' ')[0],
            "jam": now.toString().split(' ')[1],
            "files": savedFiles,
          };

          await PendingSyncLocal().upsert(
            PendingSync(
              id: pending.id,
              deliveryOrderId: doId,
              payload: jsonEncode(payload),
              createdAt: pending.createdAt,
            ),
          );

          /// =========================
          /// UPDATE SQLITE
          /// =========================
          await DeliveryOrderLocal().updateStatus(
            noDeliv: noDeliv,
            status: status,
          );

          /// =========================
          /// REFRESH UI SQLITE
          /// =========================
          await getListOnGoingDeliveryOrder();

          imageFileListPickup!.clear();

          controllerSlider.success();

          await Future.delayed(
            const Duration(seconds: 1),
          );

          controllerSlider.reset();

          Get.back();

          dialogSuccess(
            'Berhasil',
            'Data disimpan offline',
          );
        } catch (e) {
          controllerSlider.failure();

          await Future.delayed(
            const Duration(seconds: 1),
          );

          controllerSlider.reset();

          dialogError(
            'Error',
            e.toString(),
          );
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }

  // postUpdateDeliveredDo(doId, status, controllerSlider) {
  //   awd.AwesomeDialog(
  //     context: Get.context!,
  //     dialogType: awd.DialogType.question,
  //     animType: awd.AnimType.topSlide,
  //     dismissOnTouchOutside: false,
  //     dismissOnBackKeyPress: false,
  //     body: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Form(
  //         key: formKeyNamaPenerima,
  //         child: Column(
  //           children: [
  //             const Text(
  //               'Yakin akan menyelesaikan tugas delivery?\nMasukkan nama penerima!',
  //               textAlign: TextAlign.center,
  //             ),
  //             20.height,
  //             TextFormField(
  //               controller: namaPenerimaController,
  //               decoration: InputDecoration(
  //                 filled: true,
  //                 hintText: 'Nama Penerima',
  //                 contentPadding:
  //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Form harus diisi!';
  //                 }
  //                 return null;
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     btnOkText: "OK",
  //     btnOkOnPress: () {
  //       if (formKeyNamaPenerima.currentState!.validate()) {
  //         try {
  //           FormData formData = FormData({});
  //           formData.fields.add(MapEntry("userid", userId.toString()));
  //           formData.fields.add(MapEntry("delivery_order_id", doId));
  //           formData.fields
  //               .add(MapEntry("nama_penerima", namaPenerimaController.text));
  //           formData.fields.add(MapEntry("status", status));
  //           for (var file in imageFileListDelivered!) {
  //             formData.files.add(MapEntry(
  //               'file_foto[]',
  //               MultipartFile(File(file.path), filename: file.name),
  //             ));
  //           }
  //
  //           if (kDebugMode) {
  //             print(formData.fields);
  //           }
  //           controllerSlider.loading(); //starts loading animation
  //           DeliveryProvider()
  //               .postUpdateDeliveredDo(formData)
  //               .then((value) async {
  //             if (kDebugMode) {
  //               print(value.body);
  //             }
  //             if (value.status.isOk) {
  //               var success = value.body['success'];
  //               var message = value.body['message'];
  //               if (success == true) {
  //                 controllerSlider.success(); //starts success animation
  //                 await Future.delayed(const Duration(seconds: 1));
  //                 controllerSlider.reset(); //resets the slider
  //                 imageFileListDelivered!.clear();
  //                 historyC.getListHistoryDo();
  //                 getListOnGoingDeliveryOrder();
  //                 Get.back();
  //                 dialogSuccess('Berhasil', message);
  //               } else {
  //                 controllerSlider.failure(); //starts failure animation
  //                 await Future.delayed(const Duration(seconds: 1));
  //                 controllerSlider.reset(); //resets the slider
  //                 dialogWarning('Gagal', message);
  //               }
  //             } else if (value.status.isServerError) {
  //               controllerSlider.failure(); //starts failure animation
  //               await Future.delayed(const Duration(seconds: 1));
  //               controllerSlider.reset(); //resets the slider
  //               dialogError('Terjadi Kesalahan',
  //                   'Terjadi masalah pada server / koneksi internet lambat');
  //             } else if (value.status.connectionError) {
  //               controllerSlider.failure(); //starts failure animation
  //               await Future.delayed(const Duration(seconds: 1));
  //               controllerSlider.reset(); //resets the slider
  //               dialogError('Tidak ada koneksi',
  //                   'Jaringan internet bermasalah, silahkan cek koneksi internet!');
  //             }
  //           });
  //         } catch (e) {
  //           return dialogError('Terjadi Kesalahan', e.toString());
  //         }
  //       } else {
  //         dialogWarning('Warning', 'Nama penerima harus diisi...!');
  //       }
  //     },
  //     btnCancelText: "Cancel",
  //     btnCancelOnPress: () {
  //       Get.back();
  //     },
  //   ).show();
  // }
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
                  if (value == null || value.isEmpty) {
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
        if (!formKeyNamaPenerima.currentState!.validate()) {
          dialogWarning('Warning', 'Nama penerima harus diisi!');
          return;
        }

        try {
          controllerSlider.loading();

          /// =========================
          /// SAVE IMAGE PERMANENT (DROP OFF)
          /// =========================
          final savedFiles = <String>[];

          for (final file in imageFileListDelivered!) {
            final savedPath = await FileHelper.saveImagePermanently(file.path);
            savedFiles.add(savedPath);
          }

          /// =========================
          /// UPDATE STATUS DO
          /// =========================
          await DeliveryOrderLocal().updateStatus(
            noDeliv: noDeliv,
            status: status,
            namaPenerima: namaPenerimaController.text,
          );

          /// =========================
          /// INSERT HISTORY LOCAL
          /// =========================
          await HistoryDoLocal().insert(
            HistoryDo(
              id: doId,
              tglEstimasiPickup: detailDo.value!.tglEstimasiPickup,
              jamEstimasiPickup: detailDo.value!.jamEstimasiPickup,
              tglEstimasiSampai: detailDo.value!.tglEstimasiSampai,
              jamEstimasiSampai: detailDo.value!.jamEstimasiSampai,
              refDate: detailDo.value!.refDate,
              noDeliv: detailDo.value!.noDeliv,
              shipVia: detailDo.value!.shipVia,
              poNumber: detailDo.value!.poNumber,
              alamatPickup: detailDo.value!.alamatPickup,
              alamatPengiriman: detailDo.value!.alamatPengiriman,
              memo: detailDo.value!.memo ?? '',
              status: status,
              tanggalDiterima: DateTime.now(),
              jamDiterima: DateFormat(
                'HH:mm:ss',
              ).format(
                DateTime.now(),
              ),
              namaPenerima: namaPenerimaController.text,
            ),
          );

          /// =========================
          /// AMBIL DATA DETAIL TERBARU (SOURCE OF TRUTH)
          /// =========================
          final oldData = await HistoryDoDetailLocal().getByDoId(doId);

          final existingPictures = oldData[0].picture ?? [];

          /// FILTER PICKUP SAJA (PASTI CLEAN)
          final pickupPictures = existingPictures
              .where((e) => (e.keterangan ?? '').toUpperCase() == 'PICKUP')
              .toList();

          /// =========================
          /// CREATE DROP OFF BARU
          /// =========================
          final dropoffPictures = savedFiles.map((e) {
            return Picture(
              fileFoto: e,
              keterangan: 'DROP OFF',
            );
          }).toList();

          /// =========================
          /// FINAL MERGE (1 ROW ONLY)
          /// =========================
          final allPictures = <Picture>[
            ...pickupPictures,
            ...dropoffPictures,
          ];

          print(
            'FINAL PICTURES: ${allPictures.map((e) => e.toJson()).toList()}',
          );

          /// =========================
          /// UPSERT (WAJIB OVERWRITE BUKAN INSERT BARU)
          /// =========================
          final updatedDetail = HistoryDoDetail(
            id: doId,
            tglEstimasiPickup: detailDo.value!.tglEstimasiPickup,
            jamEstimasiPickup: detailDo.value!.jamEstimasiPickup,
            tglEstimasiSampai: detailDo.value!.tglEstimasiSampai,
            jamEstimasiSampai: detailDo.value!.jamEstimasiSampai,
            refDate: detailDo.value!.refDate,
            noDeliv: detailDo.value!.noDeliv,
            shipVia: detailDo.value!.shipVia,
            poNumber: detailDo.value!.poNumber,
            alamatPickup: detailDo.value!.alamatPickup,
            alamatPengiriman: detailDo.value!.alamatPengiriman,
            memo: detailDo.value!.memo ?? '',
            status: status,
            tanggalDiterima: DateTime.now(),
            jamDiterima: DateFormat('HH:mm:ss').format(DateTime.now()),
            namaPenerima: namaPenerimaController.text,
            picture: allPictures,
          );

          /// =========================
          /// UPDATE DB (BUKAN INSERT)
          /// =========================
          await HistoryDoDetailLocal().update(updatedDetail);

          final pending = await PendingSyncLocal().getByDoId(doId);

          if (pending == null) return;

          final payload = jsonDecode(pending.payload);

          final now = DateTime.now();

          payload['delivered'] = {
            "status": "DELIVERED",
            "tanggal": now.toString().split(' ')[0],
            "jam": now.toString().split(' ')[1],
            "nama_penerima": namaPenerimaController.text,
            "files": allPictures,
          };

          await PendingSyncLocal().upsert(
            PendingSync(
              id: pending.id,
              deliveryOrderId: doId,
              payload: jsonEncode(payload),
              createdAt: pending.createdAt,
            ),
          );

          /// =========================
          /// REFRESH UI
          /// =========================
          await getListOnGoingDeliveryOrder();
          repository.getHistoryDeliveryOrder(userId);

          imageFileListDelivered!.clear();
          namaPenerimaController.clear();

          controllerSlider.success();

          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();

          Get.back();

          dialogSuccess(
            'Berhasil',
            'Data delivery disimpan offline',
          );
        } catch (e) {
          controllerSlider.failure();

          await Future.delayed(const Duration(seconds: 1));
          controllerSlider.reset();

          dialogError('Terjadi Kesalahan', e.toString());
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }
}
