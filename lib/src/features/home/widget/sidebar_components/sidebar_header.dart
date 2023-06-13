import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/profile/view/profile_screen.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/theme/colors.dart';

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.padding * 2, vertical: AppSizes.p6),
        height: SizeConfig.screenHeight / 4,
        color: Colors.transparent,
        child: Obx(
          () => Stack(
            children: [
              Positioned(
                top: AppSizes.padding,
                right: 4,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        AuthController.instance.updateDriverMode(
                            AuthenticationRepository
                                .instance.firebaseUser.value);
                      },
                      child: SvgPicture.asset(
                        !AuthController.instance.isDriver.value
                            ? Assets.assetsImagesIconsDriverSwitchIcon
                            : Assets.assetsImagesDriverIconPassengerSwitchIcon,
                        width: AppSizes.padding * 2,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      AuthController.instance.isDriver.value
                          ? "Switch to Rider"
                          : 'Switch to Driver',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.whiteColor,
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),

              // User Avatar and Information
              Positioned(
                bottom: AppSizes.p8,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Get.to(() => const ProfileScreen());
                  },
                  child: FutureBuilder(
                    future: ProfileController.instance
                        .getUserData(FirebaseAuth.instance.currentUser!.email!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          UserModel userData = snapshot.data as UserModel;
                          MapController.find.userPhoto.value =
                              userData.photoUrl ?? kPlaceholder;
                          AuthController.instance.userFullName.value =
                              userData.displayName!;
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.network(
                                  userData.photoUrl ?? kPlaceholder,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                              wSizedBox2,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.displayName ?? 'John Doe',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.whiteColor),
                                  ),
                                  Text(
                                    'Edit Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.whiteColor),
                                  ),
                                  const SizedBox(height: AppSizes.p4),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.assetsImagesIconsStar,
                                        width: AppSizes.padding,
                                        color: AppColors.whiteColor,
                                      ),
                                      Text(
                                        ' 4.6',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.whiteColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
