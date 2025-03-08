import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

Widget lottieNotFound(bool isLoading) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lotties/not_found.json',
          width: 200,
          height: 200,
          fit: BoxFit.scaleDown,
        ),
        10.height,
        Text(
          isLoading? 'Loading...':
          'Data Tidak Ditemukan',
          style: Get.textTheme.titleSmall,
        )
      ],
    ),
  );
}
