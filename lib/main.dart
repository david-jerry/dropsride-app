import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/reset_password_repository.dart';
import 'package:dropsride/src/features/auth/view/email_verification_screen.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/splash/view/loading_screen.dart';
import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:dropsride/src/utils/notifications/controller/controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:dropsride/firebase_options.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';

import 'package:dropsride/src/utils/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/features/auth/controller/repository/email_verification_repository.dart';
import 'src/features/auth/controller/repository/provider_repository.dart';

final PAYSTACK_SK_API = dotenv.env['PAYSTACK_TEST_SK']!;
final PAYSTACK_PK_API = dotenv.env['PAYSTACK_TEST_PK']!;

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
  );

  // FirebaseAuth.instance.signOut();

  // initialize the shared storage
  await GetStorage.init();

  // initialize the themeController
  Get.put(ThemeModeController());
  Get.put(
    AuthenticationRepository(),
  );
  Get.put(SocialProviderRepository());
  Get.put(EmailVerificationRepository());
  Get.put(PasswordResetRepository());
  Get.put(ProfileController());
  Get.put(UserRepository());
  Get.put(AuthController());
  Get.put(MapController());

  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );

  await Permission.location.isDenied.then(
    (value) {
      if (value) {
        Permission.location.request();
      }
    },
  );

  await AwesomeNotifications().initialize(
    null, //'resource://drawable/app_icon' a default app notification icon
    [
      NotificationChannel(
        channelGroupKey: 'group_channel',
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor:
            Get.isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        ledColor: AppColors.primaryColor,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        onlyAlertOnce: true,
        criticalAlerts: true,
      )
    ],
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (receivedAction) async {
      await NotificationController.onActionReceivedMethod(receivedAction);
    },
    onDismissActionReceivedMethod: (receivedAction) async {
      await NotificationController.onDismissActionReceivedMethod(
          receivedAction);
    },
    onNotificationCreatedMethod: (receivedNotification) async {
      await NotificationController.onNotificationCreatedMethod(
          receivedNotification);
    },
    onNotificationDisplayedMethod: (receivedNotification) async {
      await NotificationController.onNotificationDisplayedMethod(
          receivedNotification);
    },
  );

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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // initialData: FirebaseAuth.instance.currentUser,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          SizeConfig.init(context);

          Timer? timer;

          if (timer != null) {
            timer.isActive ? timer.cancel() : null;
          }

          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            if (user == null) {
              return SplashScreen();
            } else {
              AssistantMethods.checkUserExist(user.uid);

              try {
                themeController.hasLoaded.value = true;
                if (!user.emailVerified) {
                  user.sendEmailVerification();
                  timer = Timer.periodic(
                    const Duration(seconds: 5),
                    (Timer timer) {
                      user.reload();
                      if (user.emailVerified) {
                        timer.isActive ? timer.cancel() : null;
                        // Get.to(() => LoadingScreen());
                        Get.offAll(() => const HomeScreen());
                      }
                    },
                  );
                  return const EmailVerificationScreen();
                } else {
                  timer!.isActive ? timer.cancel() : null;
                  return LoadingScreen();
                }
              } catch (e) {
                if (e is FirebaseAuthException) {
                  if (timer != null) {
                    timer.isActive ? timer.cancel() : null;
                  }
                  if (e.code == "user-not-found") {
                    AuthController.find.login.value = false;
                    FirebaseAuth.instance.signOut();
                  }
                }
              }
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
