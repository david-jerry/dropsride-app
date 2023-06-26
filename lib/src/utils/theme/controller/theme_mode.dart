import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// This controller handles everything concerning the theme mode, i.e [Light] or [Dark].
///---------------------------------------------------------------------------
/// How to use?
///---------------------------------------------------------------------------
/// - [**controller._loadTheme()**] You can call this function on initialization to get the current theme mode if light or dark.
///
/// - [**controller.saveTheme()**] Used to save the preference of the given user on the current operating device. Take a [bool] data type argument.
///
/// - [**controller.changeTheme(ThemeData)**] Can be called to change the theme data of the app. Accepts only a [ThemeData] data type argument.
///
/// - [**controller.changeThemeMode(ThemeMode)**] can be called to change the theme's mode from dark to light, with the initial setup set to the system mode. Accepts only a [ThemeMode] data type argument.
///---------------------------------------------------------------------------

enum AlertType {
  info,
  error,
  success,
  warning,
}

class ThemeModeController extends GetxController {
  static ThemeModeController get instance => Get.find<ThemeModeController>();

  RxBool isDarkMode = true.obs;
  RxBool hasLoaded = false.obs;

  void toggleMode() {
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }

    update();
  }
}

class ThemeBinding implements Bindings {
  /// Lazily binding the theme controller for initialization
  @override
  void dependencies() {
    Get.put(() => ThemeModeController());
  }
}
