import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProfileController.instance.takePicture();
      },
      child: Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 135,
                  height: 135,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(110),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 4.5,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ProfileController.instance.imagePreview.value ==
                                null
                            ? Image.network(
                                userData.photoUrl ?? kPlaceholder,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                ProfileController.instance.imagePreview.value!,
                                width: double.maxFinite,
                                height: double.maxFinite,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 9,
              right: 6,
              child: SvgPicture.asset(
                Assets.assetsImagesDriverIconEditProfileIcon,
                height: AppSizes.iconSize * 1.5,
              ),
            ),
            Obx(
              () => Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: AuthController.instance.isDriver.value &&
                      userData.isVerified,
                  child: SvgPicture.asset(
                    Assets.assetsImagesDriverIconVerifiedIcon,
                    height: AppSizes.iconSize * 2,
                    color: AppColors.green,
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
