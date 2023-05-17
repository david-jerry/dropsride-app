import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModeController>(
      builder: (controller) {
        return Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: controller.switchWidget(
                    Image.asset(Assets.assetsImagesLogoLogoLight),
                    Image.asset(Assets.assetsImagesLogoLogo),
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.theme == ThemeMode.dark) {
                        controller
                            .changeTheme(DropsrideTheme.dropsrideLightTheme);
                        controller.saveTheme(false);
                      } else {
                        controller
                            .changeTheme(DropsrideTheme.dropsrideDarkTheme);
                        controller.saveTheme(true);
                      }
                    },
                    child: controller.switchWidget(
                      const Text('Dark Mode'),
                      const Text('Light Mode'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
