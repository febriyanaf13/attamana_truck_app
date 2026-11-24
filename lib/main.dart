import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/services/notifikasi_service.dart';
import 'app/utils/constants.dart';
import 'app/utils/string_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  storage.write(kSesionInstall, true);
  // VERSI 52: push notification job antar (Firebase). Bila belum dikonfigurasi, aplikasi tetap jalan tanpa push.
  await NotifikasiService.pasang();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Avenir',
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
