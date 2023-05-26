import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/settings_and_legals/view/contact_screen.dart';
import 'package:dropsride/src/features/settings_and_legals/view/languages.dart';
import 'package:dropsride/src/features/settings_and_legals/view/legal_page.dart';
import 'package:dropsride/src/features/settings_and_legals/view/location.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            title: const AppBarTitle(
              pageTitle: 'Settings',
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.padding * 2),
            children: [
              ListTile(
                dense: true,
                onTap: () {
                  Get.to(() => const LanguageScreen());
                },
                leading: SvgPicture.asset(
                  Assets.assetsImagesIconsLanguage,
                  width: AppSizes.iconSize * 1.4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Language',
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
              hSizedBox2,
              ListTile(
                dense: true,
                leading: SvgPicture.asset(
                  Assets.assetsImagesIconsMode,
                  width: AppSizes.iconSize * 1.2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dark Mode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    wSizedBox2,
                    Switch.adaptive(
                      activeTrackColor: AppColors.primaryColor,
                      value: ThemeModeController.instance.isDarkMode.value,
                      onChanged: (value) {
                        ThemeModeController.instance.isDarkMode.value = value;

                        value
                            ? Get.changeThemeMode(ThemeMode.dark)
                            : Get.changeThemeMode(ThemeMode.light);
                      },
                    )
                  ],
                ),
              ),
              hSizedBox2,
              ListTile(
                dense: true,
                onTap: () {
                  Get.to(() => const LocationPermissionScreen());
                },
                leading: SvgPicture.asset(
                  Assets.assetsImagesIconsLocation,
                  width: AppSizes.iconSize * 1.4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Location',
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
              hSizedBox2,
              ListTile(
                dense: true,
                onTap: () {
                  Get.to(() => const LegalPage());
                },
                leading: SvgPicture.asset(
                  Assets.assetsImagesIconsPrivacy,
                  width: AppSizes.iconSize * 1.4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Privacy Policy',
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
              hSizedBox2,
              ListTile(
                dense: true,
                onTap: () {
                  Get.to(() => const ContactScreen());
                },
                leading: SvgPicture.asset(
                  Assets.assetsImagesIconsHelp,
                  width: AppSizes.iconSize * 1.4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Help Center',
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
            ],
          )),
    );
  }
}
