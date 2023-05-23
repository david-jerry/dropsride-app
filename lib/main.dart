import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/splash/controller/animation_controller.dart';
import 'package:dropsride/src/features/splash/view/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:dropsride/firebase_options.dart';
import 'package:dropsride/src/features/legals/view/legal_page.dart';
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
      AuthController(),
    ),
  );

  // initialize the shared storage
  await GetStorage.init();

  // initialize the themeController
  Get.put(ThemeModeController());
  Get.put(SplashScreenController());

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
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'UK'),
      initialBinding: ThemeBinding(),
      theme: DropsrideTheme.dropsrideLightTheme,
      darkTheme: DropsrideTheme.dropsrideDarkTheme,
      themeMode: themeController.theme, //ThemeMode.dark,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 700),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), // idTokenChanges(),
        builder: (context, snapshot) {
          if (Get.isSnackbarOpen) {
            Get.back(closeOverlays: true);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Get.snackbar(
            //   isDismissible: true,
            //   borderRadius: AppSizes.p4,
            //   dismissDirection: DismissDirection.down,
            //   animationDuration: const Duration(milliseconds: 1000),
            //   icon: const Icon(Icons.error_outline_rounded),
            //   duration: const Duration(milliseconds: 1200),
            //   "Authentication Info",
            //   "Please Sign up or Login to use the Drops Application!",
            //   backgroundColor: Colors.blueAccent,
            //   padding: const EdgeInsets.all(AppSizes.padding),
            //   showProgressIndicator: true,
            //   snackStyle: SnackStyle.FLOATING,
            // );
            // FirebaseAuth.instance.signOut();
            SplashScreenController.find.animateLogo.value = true;
            return SplashScreen();
          }

          if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            // Get.snackbar(
            //   isDismissible: true,
            //   borderRadius: AppSizes.p4,
            //   dismissDirection: DismissDirection.down,
            //   animationDuration: const Duration(milliseconds: 1000),
            //   icon: const Icon(Icons.error_outline_rounded),
            //   duration: const Duration(milliseconds: 1200),
            //   "Authentication Info",
            //   "Please Sign up or Login to use the Drops Application!",
            //   backgroundColor: Colors.blueAccent,
            //   padding: const EdgeInsets.all(AppSizes.padding),
            //   showProgressIndicator: true,
            //   snackStyle: SnackStyle.FLOATING,
            // );
            FirebaseAuth.instance.signOut();
            SplashScreenController.find.runAnimation.value = true;
            SplashScreenController.find.animateLogo.value = false;
            SplashScreenController.find.startLogoAnimation();
            return SplashScreen();
          }

          if (snapshot.connectionState == ConnectionState.none) {
            // Get.snackbar(
            //   isDismissible: true,
            //   borderRadius: AppSizes.p4,
            //   dismissDirection: DismissDirection.down,
            //   animationDuration: const Duration(milliseconds: 1000),
            //   icon: const Icon(Icons.error_outline_rounded),
            //   duration: const Duration(milliseconds: 1200),
            //   "Authentication Error",
            //   "There was an error connecting to the server",
            //   backgroundColor: Colors.blueAccent,
            //   padding: const EdgeInsets.all(AppSizes.padding),
            //   showProgressIndicator: true,
            //   snackStyle: SnackStyle.FLOATING,
            // );
            SplashScreenController.find.animateLogo.value = false;
            SplashScreenController.find.runAnimation.value = false;
            return const ErrorScreen();
          }

          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            // Get.snackbar(
            //   isDismissible: true,
            //   borderRadius: AppSizes.p4,
            //   dismissDirection: DismissDirection.down,
            //   animationDuration: const Duration(milliseconds: 1000),
            //   icon: const Icon(Icons.error_outline_rounded),
            //   duration: const Duration(milliseconds: 1200),
            //   "Authentication Success",
            //   "Hello! It feels so good to have you back.",
            //   backgroundColor: Colors.blueAccent,
            //   padding: const EdgeInsets.all(AppSizes.padding),
            //   showProgressIndicator: true,
            //   snackStyle: SnackStyle.FLOATING,
            // );
            SplashScreenController.find.animateLogo.value = false;
            SplashScreenController.find.runAnimation.value = false;
            return const LegalPage();
          }

          // Get.snackbar(
          //   isDismissible: true,
          //   borderRadius: AppSizes.p4,
          //   dismissDirection: DismissDirection.down,
          //   animationDuration: const Duration(milliseconds: 1000),
          //   icon: const Icon(Icons.error_outline_rounded),
          //   duration: const Duration(milliseconds: 1200),
          //   "Authentication Info",
          //   "Please Sign up or Login to use the Drops Application!",
          //   backgroundColor: Colors.blueAccent,
          //   padding: const EdgeInsets.all(AppSizes.padding),
          //   showProgressIndicator: true,
          //   snackStyle: SnackStyle.FLOATING,
          // );
          // FirebaseAuth.instance.signOut();
          SplashScreenController.find.animateLogo.value = false;
          SplashScreenController.find.runAnimation.value = true;
          SplashScreenController.find.startLogoAnimation();
          return SplashScreen();
        },
      ),
    );
  }
}
