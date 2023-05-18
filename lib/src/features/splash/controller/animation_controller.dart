import 'package:dropsride/src/features/splash/view/intro.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animateLogo = false.obs;
  RxBool animateHello = false.obs;

  Future startLogoAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    animateLogo.value = true;

    // wait 1500 microseconds to start the animatedLogo
    await Future.delayed(const Duration(milliseconds: 5500));
    animateLogo.value = false;
    await Future.delayed(const Duration(milliseconds: 1500));
    animateHello.value = true;

    // await few seconds then switch to the intro screen
    // await Future.delayed(const Duration(milliseconds: 5500));
    // TODO: Get.to(IntroScreen());
    // Get.to(() => const IntroScreen());
  }

  void goToIntro() {
    Get.to(() => const IntroScreen());
  }
}
