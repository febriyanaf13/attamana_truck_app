import 'dart:io';
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
import 'package:nb_utils/nb_utils.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../utils/constants.dart';
import '../models/delivery_order.dart';

class DeliveryController extends GetxController {
  //TODO: Implement DeliveryController

  //controller
  var historyC = Get.put(HistoryController());

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
  var detailDo = <ListDo>[].obs;

  //storage
  var userId = storage.read(kUserId);

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

  Future<void> getListDeliveryOrder() async {
    isLoadingListDo.toggle();
    var body = {"userid": userId};
    if (kDebugMode) {
      print(body);
    }
    DeliveryProvider().getListDo(body).then(
      (value) {
        var response = value.body;
        if (kDebugMode) {
          print("Response Delivery Order : $response");
        }
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            var data = value.body['data'];
            listDo.value = listDoFromJson(data);
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
        isLoadingListDo.toggle();
      },
    );
  }

  Future<void> getListOnGoingDeliveryOrder() async {
    isLoadingListOnGoingDo.toggle();
    var body = {"userid": userId};
    DeliveryProvider().getListOnGoingDo(body).then(
      (value) {
        var response = value.body;
        if (kDebugMode) {
          print("Response list On Going Delivery Order : $response");
        }
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            var data = value.body['data'];
            listOnGoingDo.value = listDoFromJson(data);
            print(listOnGoingDo);
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
        isLoadingListOnGoingDo.toggle();
      },
    );
  }

  void getDetailDeliveryOrder(id) {
    isLoadingDetailDo.toggle();
    DeliveryProvider().getDetailDo(id).then(
      (value) {
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            var data = value.body['data'];
            detailDo.value = listDoFromJson(data);
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
        isLoadingDetailDo.toggle();
      },
    );
  }

  postUpdatePickupDo(doId, status, controllerSlider) {
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
      btnOkOnPress: () {
        var body = FormData({
          "userid": 1,
          "delivery_order_id": doId,
          "status": status,
        });
        controllerSlider.loading(); //starts loading animation
        DeliveryProvider().postPickupDo(body).then((value) async {
          if (kDebugMode) {
            print(value.body);
          }
          if (value.status.isOk) {
            var success = value.body['success'];
            var message = value.body['message'];
            if (success == true) {
              controllerSlider.success(); //starts success animation
              await Future.delayed(const Duration(seconds: 1));
              controllerSlider.reset(); //resets the slider
              Get.back();
              dialogSuccess('Berhasil', message);
              getListDeliveryOrder();
            } else {
              controllerSlider.failure(); //starts failure animation
              await Future.delayed(const Duration(seconds: 1));
              controllerSlider.reset(); //resets the slider
              dialogWarning('Gagal', message);
            }
          } else if (value.status.isServerError) {
            controllerSlider.failure(); //starts failure animation
            await Future.delayed(const Duration(seconds: 1));
            controllerSlider.reset(); //resets the slider
            dialogError('Terjadi Kesalahan',
                'Terjadi masalah pada server / koneksi internet lambat');
          } else if (value.status.connectionError) {
            controllerSlider.failure(); //starts failure animation
            await Future.delayed(const Duration(seconds: 1));
            controllerSlider.reset(); //resets the slider
            dialogError('Tidak ada koneksi',
                'Jaringan internet bermasalah, silahkan cek koneksi internet!');
          }
        });
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }

  postUpdateSelesaiLoadingDo(doId, status, controllerSlider) async {
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
      btnOkOnPress: () {
        try {
          FormData formData = FormData({});
          formData.fields.add(MapEntry("userid", userId.toString()));
          formData.fields.add(MapEntry("delivery_order_id", doId));
          formData.fields.add(MapEntry("status", status));
          for (var file in imageFileListPickup!) {
            formData.files.add(MapEntry(
              'file_foto[]',
              MultipartFile(File(file.path), filename: file.name),
            ));
          }

          if (kDebugMode) {
            print(formData.fields);
          }
          controllerSlider.loading(); //starts loading animation
          DeliveryProvider()
              .postUpdateSelesaiLoadingDo(formData)
              .then((value) async {
            if (kDebugMode) {
              print(value.body);
            }
            if (value.status.isOk) {
              var success = value.body['success'];
              var message = value.body['message'];
              if (success == true) {
                controllerSlider.success(); //starts success animation
                await Future.delayed(const Duration(seconds: 1));
                controllerSlider.reset(); //resets the slider
                Get.back();
                getListOnGoingDeliveryOrder();
                imageFileListPickup!.clear();

                dialogSuccess('Berhasil', message);
              } else {
                controllerSlider.failure(); //starts failure animation
                await Future.delayed(const Duration(seconds: 1));
                controllerSlider.reset(); //resets the slider
                dialogWarning('Gagal', message);
              }
            } else if (value.status.isServerError) {
              controllerSlider.failure(); //starts failure animation
              await Future.delayed(const Duration(seconds: 1));
              controllerSlider.reset(); //resets the slider
              dialogError('Terjadi Kesalahan',
                  'Terjadi masalah pada server / koneksi internet lambat');
            } else if (value.status.connectionError) {
              controllerSlider.failure(); //starts failure animation
              dialogError('Tidak ada koneksi',
                  'Jaringan internet bermasalah, silahkan cek koneksi internet!');
            }
          });
        } catch (e) {
          controllerSlider.failure(); //starts failure animation
          return dialogError('Terjadi Kesalahan', e.toString());
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }

  postUpdateDeliveredDo(doId, status, controllerSlider) {
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
      btnOkOnPress: () {
        if (formKeyNamaPenerima.currentState!.validate()) {
          try {
            FormData formData = FormData({});
            formData.fields.add(MapEntry("userid", userId.toString()));
            formData.fields.add(MapEntry("delivery_order_id", doId));
            formData.fields
                .add(MapEntry("nama_penerima", namaPenerimaController.text));
            formData.fields.add(MapEntry("status", status));
            for (var file in imageFileListDelivered!) {
              formData.files.add(MapEntry(
                'file_foto[]',
                MultipartFile(File(file.path), filename: file.name),
              ));
            }

            if (kDebugMode) {
              print(formData.fields);
            }
            controllerSlider.loading(); //starts loading animation
            DeliveryProvider()
                .postUpdateDeliveredDo(formData)
                .then((value) async {
              if (kDebugMode) {
                print(value.body);
              }
              if (value.status.isOk) {
                var success = value.body['success'];
                var message = value.body['message'];
                if (success == true) {
                  controllerSlider.success(); //starts success animation
                  await Future.delayed(const Duration(seconds: 1));
                  controllerSlider.reset(); //resets the slider
                  imageFileListDelivered!.clear();
                  historyC.getListHistoryDo();
                  getListOnGoingDeliveryOrder();
                  Get.back();
                  dialogSuccess('Berhasil', message);
                } else {
                  controllerSlider.failure(); //starts failure animation
                  await Future.delayed(const Duration(seconds: 1));
                  controllerSlider.reset(); //resets the slider
                  dialogWarning('Gagal', message);
                }
              } else if (value.status.isServerError) {
                controllerSlider.failure(); //starts failure animation
                await Future.delayed(const Duration(seconds: 1));
                controllerSlider.reset(); //resets the slider
                dialogError('Terjadi Kesalahan',
                    'Terjadi masalah pada server / koneksi internet lambat');
              } else if (value.status.connectionError) {
                controllerSlider.failure(); //starts failure animation
                await Future.delayed(const Duration(seconds: 1));
                controllerSlider.reset(); //resets the slider
                dialogError('Tidak ada koneksi',
                    'Jaringan internet bermasalah, silahkan cek koneksi internet!');
              }
            });
          } catch (e) {
            return dialogError('Terjadi Kesalahan', e.toString());
          }
        } else {
          dialogWarning('Warning', 'Nama penerima harus diisi...!');
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Get.back();
      },
    ).show();
  }
}
