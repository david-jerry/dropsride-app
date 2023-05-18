import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/splash/controller/animation_controller.dart';
import 'package:dropsride/src/features/splash/view_models/onboarding_widget.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';

// Third party packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});
  // splash screen controller
  final SplashScreenController sController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    final pages = [
      // onboard image
      OnBoardingPages(
        image: Assets.assetsImagesOnboardOnboard1,
        text: "We provide the best services just for you",
      ),
      OnBoardingPages(
        image: Assets.assetsImagesOnboardOnboard2,
        text: "Affordable and convenient rides",
      ),
      OnBoardingPages(
        image: Assets.assetsImagesOnboardOnboard3,
        text: "Lets take you to your desired destination",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Page Swipe
            LiquidSwipe(
              liquidController: sController.liquidController,
              // enableSideReveal: true,
              // slideIconWidget: const Icon(Icons.arrow_back_ios_new),
              pages: pages,
            ),

            // start afresh
            Positioned(
              top: AppSizes.padding,
              left: AppSizes.padding,
              child: Visibility(
                visible: sController.secondIntro.value ? false : true,
                child: IconButton(
                  onPressed: () {
                    sController.gotoSplash();
                  },
                  icon: Icon(
                    Icons.repeat_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),

            // skip button
            Obx(
              () => Positioned(
                top: AppSizes.padding,
                right: AppSizes.padding,
                child: Visibility(
                  visible: sController.lastIntro.value ? false : true,
                  child: TextButton(
                    onPressed: () {
                      sController.skip();
                    },
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                ),
              ),
            ),

            Obx(
              () => Positioned(
                width: SizeConfig.screenWidth,
                bottom: AppSizes.padding * 12,
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: sController.activeIndex.value,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 6,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotHeight: AppSizes.p8,
                      dotWidth: AppSizes.p8,
                    ),
                  ),
                ),
              ),
            ),

            // next button
            Obx(
              () => Positioned(
                bottom: AppSizes.padding * 3,
                width: SizeConfig.screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding * 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.p12),
                      ),
                      elevation: AppSizes.p8,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.buttonHeight / 2.9,
                      ),
                    ),
                    onPressed: () {
                      sController.lastIntro.value
                          ? sController.goToSignUp()
                          : sController.nextSlide();
                    },
                    child: Text(
                      sController.lastIntro.value ? 'Signup' : 'Next',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: SizeConfig.screenHeight * 0.026,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
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
