import 'package:attamana_truck_app/app/modules/auth/providers/auth_provider.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/dialog/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../data/api/api_client.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController
  var user = storage.read(kUserId);
  var session = storage.read(kSesionAuth);
  var sessionInstall = storage.read(kSesionInstall);
  var version = ''.obs;

  @override
  void onInit() {
    // Future.delayed(const Duration(seconds: 3), () => reqToken());

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


  void reqToken() {
    // VERSI 50: kirim versi aplikasi (wajib di server) & akun API dari ApiClient
    AuthProvider()
        .reqToken(ApiClient.apiUsername, ApiClient.apiPassword,
            version: version.value)
        .then((value) {
      if (kDebugMode) {
        print('status_code token : ${value.statusCode}');
      }

      if (value.status.isOk && value.body is Map) {
        var success = value.body['success'];
        var message = value.body['message'];
        if (success == true) {
          storage.write('token', value.body['token']);
          storage.write(kSesionInstall, true);
          autoLogin();
        } else {
          dialogWarning('Gagal', message);
        }
      } else if (value.status.isServerError) {
        dialogError('Terjadi Kesalahan',
            'Terjadi masalah pada server / koneksi internet lambat');
      } else if (value.status.connectionError) {
        // VERSI 50: aplikasi mendukung mode offline. Bila sudah pernah login, tetap masuk
        // memakai token terakhir; data tersimpan di HP dan dikirim saat online.
        if (sessionInstall == true && session == true) {
          autoLogin();
        } else {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      }
    });
  }

  void autoLogin() {
    print("session install : $sessionInstall");
    print("session login : $session");
    if (sessionInstall != null && sessionInstall) {
      if (session != null && session) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    } else {
      Get.offNamed(Routes.WELCOME);
    }
  }

  void getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
    reqToken();
    // Future.delayed(const Duration(seconds: 3), () => autoLogin());
  }
}
