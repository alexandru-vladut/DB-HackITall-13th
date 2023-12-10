import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {this.title,
      this.color,
      this.fontFamily,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      this.textAlign,
      this.decoration,
      this.maxLines,
      this.lineHeight,
      Key? key})
      : super(key: key);
  final String? title;
  final String? fontFamily;
  final Color? color;
  final double? fontSize;
  final double? lineHeight;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      style: TextStyle(
          height: lineHeight,
          fontSize: fontSize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: decoration,
          fontStyle: fontStyle),
    );
  }
}
