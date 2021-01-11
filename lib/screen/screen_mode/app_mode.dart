import 'package:flutter/cupertino.dart';

class AppMode extends ChangeNotifier {
  bool isWatchingExpandedVideo = false;
  bool isDark = false;
  void setDarkMode(bool isDark) {
    this.isDark = isDark;
    notifyListeners();
  }

  void setFullScreen(bool isFullScreen) {
    this.isWatchingExpandedVideo = isFullScreen;
    notifyListeners();
  }
}
