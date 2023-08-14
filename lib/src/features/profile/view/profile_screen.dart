// ignore_for_file: unnecessary_null_comparison

import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/bank_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/profile/view/deactivate_account_screen.dart';
import 'package:dropsride/src/features/profile/view/favorite_destinations.dart';
import 'package:dropsride/src/features/profile/view/update/profile.dart';
import 'package:dropsride/src/features/profile/widgets/profile_widgets/driver_links.dart';
import 'package:dropsride/src/features/profile/widgets/profile_widgets/photo_holder.dart';
import 'package:dropsride/src/features/profile/widgets/profile_widgets/profile_name.dart';
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
    Get.put(ProfileController());

    // if (AuthController.find.userModel.value!.isDriver) {
    //   BankController.instance.fetchBankAccount();
    // }

    // ? the entire profile place
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Get.offAll(() => HomeScreen()),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: AppBarTitle(
          pageTitle: AuthController.find.userModel.value!.isDriver
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

      // ! body section
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.padding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hSizedBox2,
              const ProfilePhoto(),
              hSizedBox2,

              // Profile Information
              Center(
                child: Column(
                  children: [
                    // ! ----------------------------------------------------------------------------------------------
                    const ProfileNameAndEmail(),

                    // ! ----------------------------------------------------------------------------------------------
                    hSizedBox2,
                    const Divider(
                      thickness: 3,
                      color: AppColors.primaryColor,
                      indent: AppSizes.padding * 3.5,
                      endIndent: AppSizes.padding * 3.5,
                    ),

                    // ! the profile menu tiles
                    hSizedBox2,
                    ListTile(
                      onTap: () {
                        Get.to(() => ProfileUpdateScreen());
                      },
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

                    Obx(
                      () => AuthController.find.userModel.value!.isDriver
                          ? const DriverMenuItems()
                          : ListTile(
                              onTap: () {
                                Get.to(() => const FavoriteScreen());
                              },
                              dense: true,
                              leading: SvgPicture.asset(
                                Assets.assetsImagesIconsLocation,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Favorite Destinations ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  wSizedBox2,
                                  Icon(
                                    FontAwesomeIcons.angleRight,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: AppSizes.iconSize * 1.4,
                                  )
                                ],
                              ),
                            ),
                    ),

                    // ! ----------------------------------------------------------------------------------------------
                    ListTile(
                      onTap: () {
                        Get.to(() => DeactivateAccountScreen());
                      },
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

                    // ! ----------------------------------------------------------------------------------------------
                    ListTile(
                      onTap: () {
                        AuthController.find.signOutUser();
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
    );
  }
}
