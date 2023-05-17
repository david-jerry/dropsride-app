import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  ///---------------------------------------------------------------------------
  /// Splash Screen
  ///---------------------------------------------------------------------------
  /// This is a view to show immediately after the apps load screen
  /// and can change the theme of information depending on the theme mode either
  /// light or dark. This also has certain animations and uses a stacked widget to position the widgets in certain areas of the scaffolding screen
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeModeController controller = Get.find<ThemeModeController>();
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Obx(
                () {
                  return Positioned(
                      child: controller.isDarkMode.value
                          ? Image.asset(Assets.assetsImagesLogoLogoLight)
                          : Image.asset(Assets.assetsImagesLogoLogo));
                },
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,

                // elevated button to toggle dark or light mode
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isDarkMode.value) {
                      controller
                          .changeTheme(DropsrideTheme.dropsrideLightTheme);
                      controller.saveTheme(false);
                      controller.updateMode();
                    } else {
                      controller.changeTheme(DropsrideTheme.dropsrideDarkTheme);
                      controller.saveTheme(true);
                      controller.updateMode();
                    }
                  },
                  child: Obx(
                    () => controller.isDarkMode.value
                        ? const Text('Dark Mode')
                        : const Text('Light Mode'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
