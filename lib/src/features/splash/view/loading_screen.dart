import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';

// third party import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatelessWidget {
  ///---------------------------------------------------------------------------
  /// Splash Screen
  ///---------------------------------------------------------------------------
  /// This is a view to show immediately after the apps load screen
  /// and can change the theme of information depending on the theme mode either
  /// light or dark. This also has certain animations and uses a stacked widget to position the widgets in certain areas of the scaffolding screen
  LoadingScreen({Key? key}) : super(key: key);
  // theme controller
  final ThemeModeController controller = Get.find<ThemeModeController>();

  @override
  Widget build(BuildContext context) {
    // size config initialization
    SizeConfig.init(context);

    // main app scaffold
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                controller.isDarkMode.value
                    ? Assets.assetsImagesSplashDarkBg
                    : Assets.assetsImagesSplashLightBg,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // app logo
            Positioned(
              bottom: SizeConfig.screenHeight * 0.60,
              width: SizeConfig.screenWidth,
              child: Center(
                child: CircleAvatar(
                  radius: SizeConfig.screenHeight * 0.086,
                  backgroundColor: controller.isDarkMode.value
                      ? AppColors.backgroundColorLight
                      : AppColors.backgroundColorDark,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight * 0.086),
                    child: Image.asset(
                      Assets.assetsVideosCs,
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
