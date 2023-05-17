import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeModeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  bool _loadTheme() {
    final savedTheme = _box.read(_key);
    final systemThemeMode = SchedulerBinding.instance.window.platformBrightness;
    final isSystemDarkMode = systemThemeMode == Brightness.dark;

    return savedTheme ?? isSystemDarkMode;
  }

  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);
  void changeTheme(ThemeData theme) => Get.changeTheme(theme);
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

  String switchImageMode(String darkImageString, String lightImageString) {
    if (theme == ThemeMode.dark) {
      return darkImageString;
    }

    return lightImageString;
  }

  String switchTextMode(String darkTextString, String lightTextString) {
    if (theme == ThemeMode.dark) {
      return darkTextString;
    }

    return lightTextString;
  }

  Widget switchWidget(Widget darkWidget, Widget lightWidget) {
    if (theme == ThemeMode.dark) {
      return darkWidget;
    }
    return lightWidget;
  }
}

class ThemeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeModeController());
  }
}
