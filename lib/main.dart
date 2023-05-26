import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/splash/view/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:dropsride/firebase_options.dart';
import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/utils/theme/theme.dart';

void main() async {
  // ensure all app bindings have been initialized successfully
  WidgetsFlutterBinding.ensureInitialized();

  // set default phone orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');

  // initialize firebase authentication
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (value) => Get.put(
      AuthenticationRepository(),
    ),
  );

  // initialize the shared storage
  await GetStorage.init();

  // initialize the themeController
  Get.put(ThemeModeController());

  // run the main app here
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // warning: initialize theme controller
  final themeController = ThemeModeController.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    themeController.isDarkMode.value =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    themeController.toggleMode();
    return GetMaterialApp(
      title: 'Dropsride',
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'UK'),
      initialBinding: ThemeBinding(),
      theme: DropsrideTheme.dropsrideLightTheme,
      darkTheme: DropsrideTheme.dropsrideDarkTheme,
      themeMode: themeController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.system, //ThemeMode.dark,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 700),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
