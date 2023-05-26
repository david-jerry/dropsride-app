// ignore_for_file: unnecessary_null_comparison

import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Get.back(canPop: true, closeOverlays: false),
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          titleSpacing: AppSizes.padding,
          primary: true,
          scrolledUnderElevation: AppSizes.p4,
          title: AppBarTitle(
            pageTitle: AuthController.instance.isDriver.value
                ? 'Driver Profile'
                : 'Profile',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: AppSizes.padding * 2,
              ),
              child: InkWell(
                onTap: () {
                  ThemeModeController.instance.isDarkMode.value =
                      !ThemeModeController.instance.isDarkMode.value;

                  ThemeModeController.instance.isDarkMode.value
                      ? Get.changeThemeMode(ThemeMode.dark)
                      : Get.changeThemeMode(ThemeMode.light);
                },
                child: Icon(
                  ThemeModeController.instance.isDarkMode.value
                      ? FontAwesomeIcons.cloudSun
                      : FontAwesomeIcons.cloudMoon,
                  size: AppSizes.iconSize * 1.2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),

        // body
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.padding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hSizedBox2,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
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
                              child: Image.network(
                                AuthenticationRepository
                                                .instance.firebaseUser.value !=
                                            null &&
                                        AuthenticationRepository.instance
                                                .firebaseUser.value!.photoURL !=
                                            null
                                    ? FirebaseAuth
                                        .instance.currentUser!.photoURL
                                        .toString()
                                    : kPlaceholder,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        Assets.assetsImagesDriverIconEditProfileIcon,
                        height: AppSizes.iconSize * 1.5,
                      ),
                    ],
                  ),
                ),
                hSizedBox2,

                // Profile Information
                Center(
                  child: Column(
                    children: [
                      Text(
                        AuthenticationRepository.instance.firebaseUser.value !=
                                    null &&
                                AuthenticationRepository.instance.firebaseUser
                                        .value!.displayName !=
                                    null
                            ? AuthenticationRepository
                                .instance.firebaseUser.value!.displayName
                                .toString()
                            : 'John Doe',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: AppSizes.p24,
                            ),
                      ),
                      Text(
                        AuthenticationRepository.instance.firebaseUser.value !=
                                null
                            ? AuthController.instance.phoneNumber.value
                            : '+234 701 234 5678',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: AppSizes.p14,
                            ),
                      ),
                      hSizedBox2,
                      const Divider(
                        thickness: 3,
                        color: AppColors.primaryColor,
                        indent: AppSizes.padding * 3.5,
                        endIndent: AppSizes.padding * 3.5,
                      ),
                      hSizedBox2,
                      ListTile(
                        onTap: () {},
                        dense: true,
                        leading: SvgPicture.asset(
                          Assets.assetsImagesDriverIconProfileIcon,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Edit Profile',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            wSizedBox2,
                            Icon(
                              FontAwesomeIcons.angleRight,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: AppSizes.iconSize * 1.4,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        leading: SvgPicture.asset(
                          Assets.assetsImagesIconsLocation,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Favorite Destinations ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            wSizedBox2,
                            Icon(
                              FontAwesomeIcons.angleRight,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: AppSizes.iconSize * 1.4,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        leading: SvgPicture.asset(
                          Assets.assetsImagesIconsDeactivate,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Deactivate Account',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            wSizedBox2,
                            Icon(
                              FontAwesomeIcons.angleRight,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: AppSizes.iconSize * 1.4,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          AuthController.instance.signOutUser();
                        },
                        dense: true,
                        leading: SvgPicture.asset(
                            Assets.assetsImagesDriverIconLogoutIcon),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Logout',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: AppColors.red),
                              ),
                            ),
                            wSizedBox2,
                            const Icon(
                              FontAwesomeIcons.angleRight,
                              color: AppColors.red,
                              size: AppSizes.iconSize * 1.4,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
