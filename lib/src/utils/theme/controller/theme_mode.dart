import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  // RxBool get mode => isDarkMode.value ? true.obs : false.obs;

  RxBool isDarkMode = false.obs;
  String message = '';
  String title = '';
  AlertType type = AlertType.warning;

  void showMessage() {
    if (type == AlertType.info) {
      showInfoMessage(title, message, Icons.info_outline);
    } else if (type == AlertType.error) {
      showErrorMessage(title, message, Icons.error_outline);
    } else if (type == AlertType.success) {
      showSuccessMessage(title, message, Icons.mark_chat_read);
    } else {
      showWarningMessage(title, message, Icons.warning_outlined);
    }
  }

  bool _loadTheme() {
    /// Function to load the theme preference and if there is none, it checks the system's theme mode and sets it to the app theme mode
    // Get initial system mode
    Brightness systemThemeMode =
        SchedulerBinding.instance.window.platformBrightness;

    // read the share preference key for the dark or light mode
    dynamic savedTheme = _box.read(_key);

    // check if the system mode is in dark mode
    bool isSystemDarkMode = systemThemeMode == Brightness.dark;

    // set the isDarkMode bol to the correct mode
    isDarkMode.value = savedTheme ?? isSystemDarkMode;

    // return the boolean if true or false
    return savedTheme ?? isSystemDarkMode;
  }

  void saveTheme(bool isDarkMode) {
    /// write a new preference to the shared_preference of the system passing [bool] data type
    _box.write(_key, isDarkMode);
  }

  void updateMode() {
    /// Function to change the app theme mode from dark to light by passing only one arg: [themeMode] of data type [ThemeMode]
    isDarkMode.value = !isDarkMode.value;
  }

  /// change the theme of the app from dark to light mode passing just a [ThemeData] type
  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}

class ThemeBinding implements Bindings {
  /// Lazily binding the theme controller for initialization
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeModeController());
  }
}
