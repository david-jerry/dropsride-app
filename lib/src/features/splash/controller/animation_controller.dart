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
  }

  void goToIntro() async {
    animateHello.value = false;
    await Future.delayed(const Duration(milliseconds: 1500));
    Get.to(() => const IntroScreen());
  }
}
