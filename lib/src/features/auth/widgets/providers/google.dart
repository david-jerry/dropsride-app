import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignInWithGoole extends StatelessWidget {
  const SignInWithGoole({
    super.key,
    required this.aController,
  });

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.infinity),
          backgroundColor: Colors.transparent,
          foregroundColor: Get.isDarkMode
              ? AppColors.primaryColor
              : AppColors.secondaryColor,
          side: BorderSide(
            width: 2,
            color: Get.isDarkMode
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.p12),
          ),
          elevation: AppSizes.p8,
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.buttonHeight / 2.9,
          ),
        ),
        onPressed: () {
          aController.signInWithGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.assetsImagesIconsGoogle,
              width: SizeConfig.screenWidth * (1 / 12.5),
            ),
            wSizedBox4,
            Text(
              "Login with Google".toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Get.isDarkMode
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
