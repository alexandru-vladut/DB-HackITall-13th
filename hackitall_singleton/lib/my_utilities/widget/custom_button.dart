import 'package:flutter/material.dart';

import 'custom_inkwell_btn.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {this.onPressed,
      this.btnHeight,
      this.btnWidth,
      this.btnColor,
      this.btnBorderWidth,
      this.btnBorderColor,
      this.btnRadius,
      this.title,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      Key? key})
      : super(key: key);
  final Function? onPressed;
  final double? btnHeight;
  final double? btnWidth;
  final Color? btnColor;
  final double? btnBorderWidth;
  final Color? btnBorderColor;
  final double? btnRadius;
  final String? title;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onPressed,
      child: Container(
        width: btnWidth ?? double.infinity,
        height: btnHeight ?? 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [const Color.fromARGB(255, 60, 161, 122), const Color.fromARGB(255, 79, 200, 154).withOpacity(0.8)],
            //   begin: Alignment.topLeft
            // ),
            color: const Color.fromARGB(255, 73, 186, 143),
            border: Border.all(
                width: btnBorderWidth == null ? 0 : btnBorderWidth!,
                color: btnBorderColor == null
                    ? Colors.transparent
                    : btnBorderColor!),
            borderRadius: BorderRadius.circular(btnRadius == null ? 0 : btnRadius!),
            boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Change this color to suit your needs
                    spreadRadius: 1, // Increase this value to increase the spread
                    blurRadius: 5, // Increase this value to increase the blur
                    offset: const Offset(0.7, -0.7), // Change this to change the shadow's position
                )
            ]
          ),
        child: CustomText(
          title: title,
          color: textColor,
          textAlign: TextAlign.center,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
