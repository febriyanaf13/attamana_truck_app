import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../style/colors.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String title;
  final Color color, titleColor;
  final Function() onPressed;

  const CustomPrimaryButton({
    super.key,
    required this.color,
    required this.titleColor,
    required this.title, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: Get.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: Text(title,
              style:  TextStyle(fontSize: 16, color: titleColor)),
        ),
      ),
    );
  }
}
