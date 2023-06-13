import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/license_controller.dart';
import 'package:dropsride/src/features/profile/view/bank_account_screen.dart';
import 'package:dropsride/src/features/profile/view/license_screen.dart';
import 'package:dropsride/src/features/profile/view/license_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DriverMenuItems extends StatelessWidget {
  const DriverMenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            LicenseController.instance.approved.value > 1
                ? Get.to(() => const LicenseVerificationScreen())
                : Get.to(() => const DriversLicenseScreen());
          },
          dense: true,
          leading: SvgPicture.asset(
            Assets.assetsImagesDriverIconDriverLicenseIcon,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Drivers License ',
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
            Get.to(() => AccountDetailsScreen());
          },
          dense: true,
          leading: SvgPicture.asset(
            Assets.assetsImagesIconsCard,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Bank Account Detail',
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
    );
  }
}
