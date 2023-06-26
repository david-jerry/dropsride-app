import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';

// third party import
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

    MapController map = Get.find<MapController>();

    // print(AuthController.find.userModel.value!.photoUrl);
    final box = GetStorage();
    AssistantMethods.checkUserExist(FirebaseAuth.instance.currentUser!.uid);
    AssistantMethods.readOnlineUserCurrentInfo();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (FirebaseAuth.instance.currentUser != null) {
          Future.delayed(
            const Duration(milliseconds: 6500),
            () async {
              MapController.find.onBuildCompleted();
              controller.hasLoaded.value
                  ? Get.offAll(() => const HomeScreen())
                  : Get.offAll(() => SignUpScreen());
            },
          );
        }
      },
    );

    // main app scaffold
    return Scaffold(
      body: Container(
        color: controller.isDarkMode.value
            ? AppColors.secondaryColor
            : AppColors.primaryColor,
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
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                  ),
                ),
              ),
            ),

            if (FirebaseAuth.instance.currentUser != null)
              Transform.translate(
                offset: Offset(
                    -SizeConfig.screenHeight * 2, -SizeConfig.screenWidth * 2),
                child: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: map.currentUserMarkerKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white100,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              box.read('userPhotoUrl') ?? kPlaceholder,
                              fit: BoxFit.contain,
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),
                      ),

                      // pickup marker
                      RepaintBoundary(
                        key: map.pickupKey,
                        child: SvgPicture.asset(
                          Assets.assetsImagesIconsUserMarker,
                          height: 65,
                          width: 65,
                        ),
                      ),

                      RepaintBoundary(
                        key: map.dropoffKey,
                        child: SvgPicture.asset(
                          Assets.assetsImagesIconsDestinationMarker,
                          height: 65,
                          width: 65,
                        ),
                      ),
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
