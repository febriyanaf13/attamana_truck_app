import 'package:attamana_truck_app/app/components/widget/custom_primary_button.dart';
import 'package:attamana_truck_app/app/routes/app_pages.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kSecondaryColor, kAccentColor, kAccentColor2],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
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
                  20.height,
                  const Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Please input your details',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w100),
                  ),
                  50.height,
                  TextField(
                    controller: controller.usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  20.height,
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  10.height,
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  20.height,
                  Obx(
                    () => controller.isLoadingLogin.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          )
                        : CustomPrimaryButton(
                            color: kPrimaryColor,
                            titleColor: Colors.white,
                            title: 'Login',
                            onPressed: () {
                              controller.onTapLogin();
                            }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
