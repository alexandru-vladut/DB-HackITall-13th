import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {
  bool isSwitch = false;

  changeIsLoading(bool value) {
    isSwitch = value;
    notifyListeners();
  }
}
