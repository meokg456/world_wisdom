import 'package:flutter/cupertino.dart';

class ScreenMode extends ChangeNotifier {
  bool isFullScreen = false;
  void setFullScreen(bool isFullScreen) {
    this.isFullScreen = isFullScreen;
    notifyListeners();
  }
}
