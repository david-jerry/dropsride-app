import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/splash/controller/animation_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';

// third party import
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  ///---------------------------------------------------------------------------
  /// Splash Screen
  ///---------------------------------------------------------------------------
  /// This is a view to show immediately after the apps load screen
  /// and can change the theme of information depending on the theme mode either
  /// light or dark. This also has certain animations and uses a stacked widget to position the widgets in certain areas of the scaffolding screen
  SplashScreen({Key? key}) : super(key: key);
  // theme controller
  final ThemeModeController controller = Get.find<ThemeModeController>();

  // splash screen controller
  final SplashScreenController sController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    // size config initialization
    SizeConfig.init(context);
    sController.startLogoAnimation();

    // main app scaffold
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // background image
            Obx(
              () => Positioned(
                child: Image.asset(
                  controller.isDarkMode.value
                      ? Assets.assetsImagesSplashDarkBg
                      : Assets.assetsImagesSplashLightBg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // app logo
            Obx(
              () => Positioned(
                bottom: SizeConfig.screenHeight * 0.50,
                width: SizeConfig.screenWidth,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: sController.animateLogo.value ? 1 : 0,
                    duration: const Duration(milliseconds: 1500),
                    child: CircleAvatar(
                      radius: SizeConfig.screenHeight * 0.08,
                      backgroundImage: const AssetImage(
                        Assets.assetsVideosCs,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // animated texts
            Obx(
              () => Positioned(
                bottom: SizeConfig.screenHeight * 0.50,
                width: SizeConfig.screenWidth,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2500),
                  opacity: sController.animateHello.value ? 1 : 0,
                  child: Center(
                    child: Visibility(
                      visible: sController.animateHello.value ? true : false,
                      child: AnimatedTextKit(
                        totalRepeatCount: 8,
                        repeatForever: true,
                        isRepeatingAnimation:
                            sController.animateHello.value ? true : false,
                        animatedTexts: [
                          FadeAnimatedText(
                            'Hello!',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: SizeConfig.screenHeight * 0.09,
                                  fontWeight: FontWeight.w900,
                                  color: controller.isDarkMode.value
                                      ? AppColors.backgroundColorLight
                                      : AppColors.backgroundColorDark,
                                ),
                          ),
                          FadeAnimatedText(
                            'Bawo!',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: SizeConfig.screenHeight * 0.09,
                                  fontWeight: FontWeight.w900,
                                  color: controller.isDarkMode.value
                                      ? AppColors.backgroundColorLight
                                      : AppColors.backgroundColorDark,
                                ),
                          ),
                          FadeAnimatedText(
                            'Sannu!',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: SizeConfig.screenHeight * 0.09,
                                  fontWeight: FontWeight.w900,
                                  color: controller.isDarkMode.value
                                      ? AppColors.backgroundColorLight
                                      : AppColors.backgroundColorDark,
                                ),
                          ),
                          FadeAnimatedText(
                            'Nnọọ!',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: SizeConfig.screenHeight * 0.09,
                                  fontWeight: FontWeight.w900,
                                  color: controller.isDarkMode.value
                                      ? AppColors.backgroundColorLight
                                      : AppColors.backgroundColorDark,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // animated button
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                bottom: sController.animateHello.value
                    ? AppSizes.padding * 3
                    : -(AppSizes.padding * 3),
                width: SizeConfig.screenWidth,
                child: AnimatedOpacity(
                  opacity: sController.animateHello.value ? 1 : 0,
                  duration: const Duration(milliseconds: 1700),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding * 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.p12),
                        ),
                        elevation: AppSizes.p8,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.buttonHeight / 2.9,
                        ),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        // builder: ((context) => const IntroScreen())));
                        sController.goToIntro();
                        // if (controller.isDarkMode.value) {
                        //   controller.changeTheme(DropsrideTheme.dropsrideLightTheme);
                        //   controller.saveTheme(false);
                        //   controller.updateMode();
                        // } else {
                        //   controller.changeTheme(DropsrideTheme.dropsrideDarkTheme);
                        //   controller.saveTheme(true);
                        //   controller.updateMode();
                        // }
                      },
                      child: Text('Get Started',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontSize: SizeConfig.screenHeight * 0.026,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.secondaryColor,
                                  )),
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
