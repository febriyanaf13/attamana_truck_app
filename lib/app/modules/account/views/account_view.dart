import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: kPrimaryColor),
                  child:  Center(
                    child: Text(
                      controller.userNama.substring(0, 2),
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ),
                30.height,
                 Text(
                  controller.userNama,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                20.height,
                const Divider(),
                20.height,
                Row(
                  children: [
                    Image.asset(
                      'driver_license'.png,
                      scale: 15,
                      color: Colors.grey,
                    ),
                    10.width,
                    const Text(
                      'Driver License',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                20.height,
                Row(
                  children: [
                    Image.asset(
                      'faq'.png,
                      scale: 15,
                      color: Colors.grey,
                    ),
                    10.width,
                    const Text(
                      'Support/FAQ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                20.height,
                Row(
                  children: [
                    Image.asset(
                      'customer_service'.png,
                      scale: 15,
                      color: Colors.grey,
                    ),
                    10.width,
                    const Text(
                      'Customer Service',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                20.height,
                const Spacer(),
                Row(
                  children: [
                    Image.asset(
                      'sign_out'.png,
                      scale: 15,
                      color: Colors.red,
                    ),
                    10.width,
                    const Text(
                      'Sign Out',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ).onTap(()=> controller.authC.onTapSignOut()),
                  ],
                ),
                100.height
              ],
            ),
          ),
        ),
      ),
    );
  }
}
