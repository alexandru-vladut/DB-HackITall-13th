import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField(
      {this.obscureText,
      this.focusNode,
      this.onChanged,
      this.cursorColor,
      this.validation,
      this.controller,
      this.keyboardType,
      this.hintText,
      this.isFilled,
      this.isUnderlineInputBorder,
      this.isOutlineInputBorder,
      this.isOutlineInputBorderColor,
      this.maxLength,
      this.fontSize,
      this.inputFormatters,
      this.onTap,
      this.fillColor,
      this.fieldborderColor,
      this.fieldborderRadius,
      this.maxLines,
      this.contentPaddingLeft,
      this.contentPaddingRight,
      this.contentPaddingTop,
      this.contentPaddingBottom,
      this.textColor,
      this.hintTextColor,
      this.hintFontSize,
      this.textFontSize,
      this.textAlign,
      this.prefixIcon,
      this.suffixIcon,
      this.labelText,
      this.enabled,
      this.hintMaxLines,
      this.onFieldSubmitted,
      Key? key})
      : super(key: key);

  final bool? obscureText;
  final String? Function(String?)? validation;
  final Function(String)? onChanged;
  final Function? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool? isFilled;
  final bool? isUnderlineInputBorder;
  final bool? isOutlineInputBorder;
  final Color? isOutlineInputBorderColor;
  final int? maxLength;
  final int? maxLines;
  final double? fontSize;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final Color? cursorColor;
  final Color? fieldborderColor;
  final Color? textColor;
  final Color? hintTextColor;
  final double? textFontSize;
  final double? hintFontSize;
  final double? fieldborderRadius;
  final double? contentPaddingTop;
  final double? contentPaddingBottom;
  final double? contentPaddingLeft;
  final double? contentPaddingRight;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final bool? enabled;
  final int? hintMaxLines;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: fillColor ?? Colors.transparent,
          border: Border.all(
              width: fieldborderColor != null ? 0 : 1,
              color: fieldborderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(fieldborderRadius ?? 4)),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        obscureText: obscureText ?? false,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        focusNode: focusNode,
        //onTap: ()=> onTap!()!,
        validator: validation,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        textAlign: textAlign ?? TextAlign.left,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: kBlackColor, fontSize: 14),
          contentPadding: EdgeInsets.only(
              left: contentPaddingLeft ?? 12,
              right: contentPaddingRight ?? 12,
              top: contentPaddingTop ?? 13,
              bottom: contentPaddingBottom ?? 13),
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: hintFontSize ?? 18,
              color: hintTextColor ?? Colors.grey),
          hintMaxLines: hintMaxLines,
          helperStyle: const TextStyle(color: Colors.red, fontSize: 10),
          errorStyle: const TextStyle(color: Colors.red),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          //  filled: true,
          //  fillColor: isOutlineInputBorderColor,
          border: isUnderlineInputBorder == false &&
                  isOutlineInputBorder == false
              ? InputBorder.none
              : isOutlineInputBorder == false
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          width: isOutlineInputBorderColor != null ? 0 : 1,
                          color:
                              isOutlineInputBorderColor ?? Colors.transparent)),
          enabledBorder: isUnderlineInputBorder == false ||
                  isOutlineInputBorder == false
              ? InputBorder.none
              : isOutlineInputBorder == false
                  ? const UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.transparent))
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                          width: isOutlineInputBorderColor != null ? 0 : 1,
                          color:
                              isOutlineInputBorderColor ?? Colors.transparent)),
          focusedBorder: isUnderlineInputBorder == false ||
                  isOutlineInputBorder == false
              ? InputBorder.none
              : isOutlineInputBorder == false
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          width: isOutlineInputBorderColor != null ? 0 : 1,
                          color:
                              isOutlineInputBorderColor ?? Colors.transparent),
                    ),
          errorBorder: isUnderlineInputBorder == false &&
                  isOutlineInputBorder == false
              ? InputBorder.none
              : isOutlineInputBorder == false
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          width: isOutlineInputBorderColor != null ? 0 : 1,
                          color:
                              isOutlineInputBorderColor ?? Colors.transparent)),
        ),
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: textFontSize ?? 18,
        ),
      ),
    );
  }
}
