import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // ensure all app bindings have been initialized successfully
  WidgetsFlutterBinding.ensureInitialized();

  // set default phone orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
  final themeController = Get.find<ThemeModeController>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dropsride',
      initialBinding: ThemeBinding(),
      theme: DropsrideTheme.dropsrideLightTheme,
      darkTheme: DropsrideTheme.dropsrideDarkTheme,
      themeMode: themeController.theme, //ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
