import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeModeController controller = Get.find<ThemeModeController>();

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // background image
            Positioned(
              child: Image.asset(
                controller.isDarkMode.value
                    ? Assets.assetsImagesSplashDarkBg
                    : Assets.assetsImagesSplashLightBg,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // app logo
            Positioned(
              bottom: SizeConfig.screenHeight * 0.60,
              width: SizeConfig.screenWidth,
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.screenHeight * 0.086,
                      backgroundColor: controller.isDarkMode.value
                          ? AppColors.backgroundColorLight
                          : AppColors.backgroundColorDark,
                      child: CircleAvatar(
                        radius: SizeConfig.screenHeight * 0.08,
                        backgroundImage: const AssetImage(
                          Assets.assetsVideosCs,
                        ),
                      ),
                    ),
                    hSizedBox4,
                    Expanded(
                      child: Text(
                        'There was an error connecting to the server. Please check your network and retry the app again.',
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
