import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MapController map = Get.find<MapController>();

    AssistantMethods.checkUserExist(FirebaseAuth.instance.currentUser!.uid);
    AssistantMethods.readOnlineUserCurrentInfo();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(const Duration(milliseconds: 6500), () async {
          MapController.find.onBuildCompleted();
        });
      },
    );

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    hSizedBox14,
                    const Icon(
                      Icons.mail_outline_rounded,
                      size: AppSizes.iconSize * 5,
                    ),
                    hSizedBox4,
                    Text(
                      'Email Verification',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    hSizedBox2,
                    Text(
                      'A verification Email has been sent to your mail box address: ${AuthController.find.user.value!.email}.\n\n You do not need to close the app. Once you have verified your account, we shall redirect you automatically.\n\nIf you did not get this email, try resending it again by clicking the button below.',
                      textAlign: TextAlign.center,
                    ),
                    hSizedBox4,
                    TextButton(
                        onPressed: () async {
                          await AuthController.find.resendVerificationEmail();
                        },
                        child: Text('Resend Email',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w900,
                                    ))),
                    hSizedBox4,
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await FirebaseAuth.instance.currentUser!.delete();
                        Get.offAll(() => SignUpScreen());
                      },
                      child: Text(
                        'Delete Account',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ],
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
                              AuthController.find.userModel.value?.photoUrl ??
                                  kPlaceholder,
                              fit: BoxFit.contain,
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),
                      ),

                      RepaintBoundary(
                        key: map.driverMarkerMaoKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.transparent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset(
                              Assets.assetsImagesDriverIconCarTop,
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
