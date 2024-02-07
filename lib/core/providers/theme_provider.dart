import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:videohub/core/utils/constants.dart';

class ThemeProvider with ChangeNotifier {

  ThemeProvider(this._isDark);

  bool _isDark = false;
  bool get isDark => _isDark;

  void setTheme(bool val) async {
    print(isDark);
    print(val);
    Box themeBox = await Hive.openBox(themeBoxLabel);
    themeBox.put(isDarkKey, val);
    _isDark = val;
    notifyListeners();
  }
}