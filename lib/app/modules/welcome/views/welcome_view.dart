import 'package:attamana_truck_app/app/routes/app_pages.dart';
import 'package:attamana_truck_app/app/style/colors.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/widget/custom_primary_button.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: Get.height,
              width: Get.width,
              child: Image.asset(
                'bg_welcome'.jpg,
                fit: BoxFit.cover,
              )),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'logo_attamana'.png,
                              width: 50,
                              height: 50,
                            ),
                            10.width,
                            const Text(
                              'Attamana',
                              style: TextStyle(
                                  fontFamily: 'Baloo',
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fast and Easy Delivery Requests',
                          style: TextStyle(
                              fontFamily: 'Baloo',
                              fontSize: 30,
                              color: Colors.white),
                        ),
                        20.height,
                        const Text(
                          'Delivery available on request,\nany time and place.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const Spacer(),
                        CustomPrimaryButton(
                          title: 'Get Started',
                          color: kPrimaryColor,
                          titleColor: Colors.white,
                          onPressed: () {
                            storage.write(kSesionInstall, true);
                            Get.offNamed(Routes.LOGIN);
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
