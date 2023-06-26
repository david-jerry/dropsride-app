import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/widget/sidebar_components/sidebar_header.dart';
import 'package:dropsride/src/features/vehicle/view/vehicle.dart';
import 'package:dropsride/src/features/transaction/view/earnings.dart';
import 'package:dropsride/src/features/transaction/view/payment.dart';
import 'package:dropsride/src/features/trips/view/driver_trip_history.dart';
import 'package:dropsride/src/features/trips/view/free_trips.dart';
import 'package:dropsride/src/features/settings_and_legals/view/live_support.dart';
import 'package:dropsride/src/features/settings_and_legals/view/settings.dart';
import 'package:dropsride/src/features/trips/view/trip_history.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Drawer(
        backgroundColor: AppColors.primaryColor,
        elevation: AppSizes.p4,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                Assets.assetsImagesLighterCityBackground,
                fit: BoxFit.cover,
                width: double.infinity,
                height: AppSizes.buttonHeight * 6,
              ),
            ),

            // Nav Links and Header
            Positioned(
              child: Column(
                children: [
                  const SideBarHeader(),
                  const Divider(
                    indent: AppSizes.padding * 2,
                    endIndent: AppSizes.padding * 2,
                    color: AppColors.whiteColor,
                    thickness: 2,
                  ),
                  hSizedBox4,
                  AuthController.find.userModel.value!.isDriver
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.padding),
                          child: Column(
                            children: [
                              // Vehicle
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.carSide,
                                    color: AppColors.whiteColor),
                                title: Text(
                                  'Vehicle',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.whiteColor),
                                ),
                                dense: true,
                                onTap: () {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const VehicleScreen());
                                },
                              ),

                              // Earnings
                              hSizedBox2,
                              ListTile(
                                leading: SvgPicture.asset(
                                    Assets.assetsImagesIconsNairaIcon,
                                    width: AppSizes.padding * 1.5,
                                    color: AppColors.whiteColor),
                                title: Text(
                                  'Earnings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.whiteColor),
                                ),
                                dense: true,
                                onTap: () {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const EarningScreen());
                                },
                              ),
                              hSizedBox2,

                              // Trip history
                              ListTile(
                                leading: SvgPicture.asset(
                                    Assets
                                        .assetsImagesDriverIconTripHistoryClock,
                                    width: AppSizes.padding * 1.5,
                                    color: AppColors.whiteColor),
                                title: Text(
                                  'Trip History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.whiteColor),
                                ),
                                dense: true,
                                onTap: () {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const DriverTripHistory());
                                },
                              ),
                              hSizedBox2,
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.padding),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  FontAwesomeIcons.creditCard,
                                  color: AppColors.whiteColor,
                                ),
                                title: Text(
                                  'Payment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.whiteColor,
                                      ),
                                ),
                                dense: true,
                                onTap: () async {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const PaymentScreen());
                                },
                              ),
                              hSizedBox2,

                              // passenger trip history
                              ListTile(
                                leading: SvgPicture.asset(
                                    Assets
                                        .assetsImagesDriverIconTripHistoryClock,
                                    width: AppSizes.padding * 1.5,
                                    color: AppColors.whiteColor),
                                title: Text(
                                  'Trip History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.whiteColor,
                                      ),
                                ),
                                dense: true,
                                onTap: () {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const TripHistory());
                                },
                              ),
                              hSizedBox2,

                              // passenger free trips by watching ads
                              ListTile(
                                leading: SvgPicture.asset(
                                    Assets.assetsImagesIconsBag,
                                    width: AppSizes.padding * 1.5,
                                    color: AppColors.whiteColor),
                                title: Text(
                                  'Free Trips',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.whiteColor,
                                      ),
                                ),
                                dense: true,
                                onTap: () {
                                  Get.back(closeOverlays: true);
                                  Get.to(() => const FreeTripScreen());
                                },
                              ),
                              hSizedBox2,
                            ],
                          ),
                        ),

                  // Settings
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        Assets.assetsImagesDriverIconSettingsIcon,
                        width: AppSizes.padding * 1.9,
                        color: AppColors.whiteColor,
                      ),
                      title: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.whiteColor),
                      ),
                      dense: true,
                      onTap: () {
                        Get.back(closeOverlays: true);
                        Get.to(() => const SettingsScreen());
                      },
                    ),
                  ),
                  hSizedBox2,

                  // Support
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        Assets.assetsImagesIconsSupport,
                        width: AppSizes.padding * 1.9,
                        color: AppColors.whiteColor,
                      ),
                      title: Text(
                        'Support',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.whiteColor),
                      ),
                      dense: true,
                      onTap: () {
                        Get.back(closeOverlays: true);
                        Get.to(() => const CustomerSupport());
                      },
                    ),
                  ),
                  hSizedBox2,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
