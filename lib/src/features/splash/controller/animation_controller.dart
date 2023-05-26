import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/splash/view/intro.dart';
import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.put(SplashScreenController());

  RxBool animateLogo = false.obs;
  RxBool animateHello = false.obs;
  RxBool lastIntro = false.obs;
  RxBool secondIntro = false.obs;
  RxInt activeIndex = 0.obs;
  RxBool runAnimation = true.obs;

  LiquidController liquidController = LiquidController();

  Future startLogoAnimation() async {
    if (runAnimation.value) {
      animateLogo.value = true;
      await Future.delayed(const Duration(milliseconds: 5500));
      animateLogo.value = false;
      await Future.delayed(const Duration(milliseconds: 1500));
      animateHello.value = true;
    }
  }

  void goToIntro() {
    animateLogo.value = false;
    animateHello.value = false;
    Get.offAll(
      () => IntroScreen(),
      transition: Transition.upToDown,
      duration: const Duration(milliseconds: 1000),
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
    Get.offAll(
      () => SplashScreen(),
      transition: Transition.leftToRight,
      duration: const Duration(milliseconds: 1000),
    );
  }

  void goToSignUp() {
    Get.offAll(
      () => SignUpScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 800),
    );
  }

  void nextSlide() {
    activeIndex.value++;
    liquidController.animateToPage(page: activeIndex.value);
    activeIndex.value > 1 ? lastIntro.value = true : lastIntro.value = false;
  }
}
