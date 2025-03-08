import 'package:action_slider/action_slider.dart';
import 'package:attamana_truck_app/app/style/colors.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/welcome_controller.dart';

class SplashViewView extends GetView<WelcomeController> {
  const SplashViewView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.session;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kSecondaryColor, kAccentColor, kAccentColor2],
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            Image.asset(
              'logo_attamana'.png,
              scale: 5,
            ),
            20.height,
            const SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Attamana',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 35,
                        color: Colors.white),
                  ),
                  Text(
                    'For Truck',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // const Text(
            //   'Version : 1.0.0',
            //   textAlign: TextAlign.end,
            //   style: TextStyle(fontSize: 12),
            // ),
            Obx(
                  () => Text(
                'Version ${controller.version}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kSecondaryTextColor),
              ),
            ),
            20.height
          ],
        )),
      ),
    );
  }
}
