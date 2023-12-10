import 'dart:developer';

import 'package:flutter/material.dart';

import 'animation/slideleft_toright.dart';
import 'animation/slideright_toleft.dart';

class Helper {
  static setHeight(BuildContext context, {height = 1}) {
    return MediaQuery.of(context).size.height * height;
  }

  static toRemoveUntiScreen(context, screen) {
    Navigator.pushAndRemoveUntil(
        context, SlideRightToLeft(page: screen), (route) => false);
  }

  static setWidth(BuildContext context, {width = 1}) {
    return MediaQuery.of(context).size.width * width;
  }

  static toScreen(context, screen) {
    Navigator.push(context, SlideRightToLeft(page: screen));
  }

  static toReplacementScreen(context, screen) {
    Navigator.pushReplacement(context, SlideRightToLeft(page: screen));
  }

  static toReplacementScreenRight(context, screen) {
    Navigator.pushReplacement(context, SlideLeftToRight(page: screen));
  }

  static showSnack(context, message,
      {color = Colors.transparent, duration = 4}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.transparent),
        ),
        backgroundColor: color,
        duration: Duration(seconds: duration)));
  }

  static circulProggress(context) {
    const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      ),
    );
  }

  static showLog(message) {
    log("APP SAYS: $message");
  }

  static boxDecoration(Color color, double radius) {
    BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }
}
