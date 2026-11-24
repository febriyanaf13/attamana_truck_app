import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../data/models/user.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/string_utils.dart';
import '../providers/auth_provider.dart';
import '../../../services/notifikasi_service.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController

  final scafoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var token = storage.read('token');
  var version = ''.obs;

  RxBool isObscure = true.obs;
  var isLoadingLogin = false.obs;

  @override
  void onInit() {
    getVersionApp();
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

  isObscureActive() {
    isObscure.value = !isObscure.value;
  }

  void getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
  }

  Future<void> onTapLogin() async {
    if (formKey.currentState!.validate()) {
      isLoadingLogin.toggle();
      AuthProvider()
          .postLogin(usernameController.text, passwordController.text,
              storage.read('token') ?? '') // VERSI 50: token terbaru
          .then((value) async {
        var response = value.body;
        if (kDebugMode) {
          print("response login : $response");
        }
        isLoadingLogin.toggle();
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          var data = value.body['data'];
          print(value.body);
          print(success);
          List<String> listStringGedung = [];
          List<String> listNamaGedung = [];

          if (success == true) {
            var jsonData = userFromJson(data);
            storage.write(kSesionAuth, true);
            storage.write(kUserNama, jsonData[0].nama);
            storage.write(kUserId, jsonData[0].userid);
            storage.write(kUserEmail, jsonData[0].email);
            storage.write(kUserTelp, jsonData[0].telepon);

            var roles = jsonData[0].roles;
            var statusKaryawan = jsonData[0].statusKaryawan;

            var sessionInstall = storage.read(kSesionInstall);
            var sessionLogin = storage.read(kSesionAuth);

            print("session install : $sessionInstall");
            print("session login : $sessionLogin");

            // awd.AwesomeDialog(
            //    context: Get.context!,
            //    dialogType: awd.DialogType.success,
            //    animType: awd.AnimType.topSlide,
            //    body: Column(
            //      mainAxisAlignment: MainAxisAlignment.start,
            //      children: [
            //        Text('SELECT ROLE', style: Get.textTheme.titleLarge),
            //        MediaQuery.removePadding(
            //          removeTop: true,
            //          context: Get.context!,
            //          child: ListView.separated(
            //            shrinkWrap: true,
            //            physics: const BouncingScrollPhysics(),
            //            itemCount: roles.length,
            //            padding: const EdgeInsets.all(20),
            //            dragStartBehavior: DragStartBehavior.start,
            //            itemBuilder: (BuildContext context, int index) {
            //              return ListTile(
            //                leading: const Icon(
            //                  Icons.person,
            //                  color: kPrimaryColor,
            //                ),
            //                title: Text(roles[index].roleName),
            //                onTap: () {
            //                  storage.write(kRoleName, roles[index].roleName);
            //
            //                  // Future.delayed(const Duration(seconds: 1), () {
            //                  //   if (roles[index].roleName == 'SUPER ADMIN') {
            //                  //     Get.offAllNamed(Routes.DASHBOARD);
            //                  //   } else if (roles[index].roleName == 'SALES') {
            //                  //     Get.offAllNamed(Routes.DASHBOARD);
            //                  //   }
            //                    Get.offAllNamed(Routes.DASHBOARD);
            //                  // });
            //                },
            //              );
            //            },
            //            separatorBuilder: (BuildContext context, int index) {
            //              return const Divider();
            //            },
            //          ),
            //        ),
            //      ],
            //    ),
            //  ).show();

            Get.offNamed(Routes.DASHBOARD);
          } else {
            dialogWarning('Ops...', message);
          }
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      });
    }
  }

  Future<void> onTapSignOut() async {
    if (kDebugMode) {
      print("logout");
    }

    awd.AwesomeDialog(
      context: Get.context!,
      title: 'Sign Out',
      desc: 'Yakin ingin keluar?',
      btnOkText: 'Ya',
      btnOkIcon: Icons.check,
      btnOkOnPress: () {
        // VERSI 52: HP berhenti menerima notifikasi job user ini (token dibaca sebelum status login dihapus)
        if (Get.isRegistered<NotifikasiService>()) {
          NotifikasiService.to.hapusToken();
        }
        storage.remove(kLogin);
        storage.write(kSesionAuth, false);
        Get.offAllNamed(Routes.LOGIN);
      },
      btnCancelText: 'Tidak',
      btnCancelIcon: Icons.close,
      btnCancelOnPress: () => Get.back(),
      dialogType: awd.DialogType.question,
    ).show();
  }
}
