import 'package:dropsride/src/features/auth/view/sign_up.dart';
import 'package:dropsride/src/features/splash/view/intro.dart';
import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animateLogo = false.obs;
  RxBool animateHello = false.obs;
  RxBool lastIntro = false.obs;
  RxBool secondIntro = false.obs;
  RxInt activeIndex = 0.obs;

  LiquidController liquidController = LiquidController();

  Future startLogoAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    animateLogo.value = true;

    // wait 1500 microseconds to start the animatedLogo
    await Future.delayed(const Duration(milliseconds: 5500));
    animateLogo.value = false;
    await Future.delayed(const Duration(milliseconds: 1500));
    animateHello.value = true;
  }

  void goToIntro() {
    animateLogo.value = false;
    animateHello.value = false;
    Get.off(
      () => IntroScreen(),
      transition: Transition.upToDown,
      duration: const Duration(milliseconds: 800),
    );
  }

  void skip() {
    lastIntro.value = true;
    activeIndex.value = 2;
    liquidController.jumpToPage(page: 2);
  }

  void gotoSplash() {
    lastIntro.value = false;
    activeIndex.value = 0;
    liquidController.animateToPage(page: 0);
    Get.off(
      () => SplashScreen(),
      transition: Transition.leftToRight,
      duration: const Duration(milliseconds: 800),
    );
  }

  void goToSignUp() {
    Get.off(
      () => SignUpScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 800),
    );
  }

  void nextSlide() {
    activeIndex.value++;
    liquidController.animateToPage(page: activeIndex.value);
    activeIndex.value > 1 ? lastIntro.value = true : lastIntro.value = false;
  }
}
