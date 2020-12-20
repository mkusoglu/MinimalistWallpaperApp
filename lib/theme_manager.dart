import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeManager extends ValueNotifier<ThemeMode>{
  ThemeManager._internal(ThemeMode themeMode) : super(themeMode);
  static ThemeManager _themeManager = ThemeManager._internal(ThemeMode.light);
  //returns
  static ThemeManager get notifier =>_themeManager;
  ///sets
  static void setTheme(ThemeMode themeMode){
  _themeManager.value=themeMode;
}

}