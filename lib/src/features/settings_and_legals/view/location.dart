import 'package:dotted_border/dotted_border.dart';
import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: AppSizes.padding,
        leading: IconButton(
          onPressed: () => Get.back(canPop: true, closeOverlays: false),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(
          pageTitle: 'Location',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Image.asset(
                Assets.assetsImagesLighterCityBackgroundYellow,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              child: Center(
                child: Column(
                  children: [
                    hSizedBox8,
                    ThemeModeController.instance.isDarkMode.value
                        ? Image.asset(
                            Assets.assetsImagesEnableLocationIllustrationDark)
                        : Image.asset(
                            Assets.assetsImagesEnableLocationIllustration),
                    hSizedBox4,
                    Text(
                      'Hi there, nice to meet you!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w900),
                    ),
                    hSizedBox8,
                    Text(
                      'Choose your location so we can find the\nbest spots around you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: !ThemeModeController.instance.isDarkMode.value
                              ? const Color.fromARGB(192, 158, 158, 158)
                              : const Color.fromARGB(159, 245, 245, 245)),
                    ),
                    hSizedBox4,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 1 / 4 - 8),
                      child: DottedBorder(
                        radius: const Radius.circular(AppSizes.padding * 2),
                        color: Theme.of(context).colorScheme.primary,
                        dashPattern: const [10, 5],
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              style: BorderStyle.none,
                            )),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text(
                                  'Use current location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.bold),
                                ),
                                wSizedBox2,
                                SvgPicture.asset(
                                  Assets.assetsImagesIconsLocation,
                                  width: AppSizes.padding * 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                )
                              ],
                            )),
                      ),
                    ),
                    hSizedBox2,
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Select it manually',
                        ))
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
