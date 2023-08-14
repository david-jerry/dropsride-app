import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DriverBottomSheet extends StatelessWidget {
  const DriverBottomSheet({super.key, required this.map});

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (map.bottomSheetDragOffset.value < 0 &&
              map.bottomSheetHeight.value < 221) {
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value = 230.0;
          } else if (map.bottomSheetDragOffset.value > 0 &&
              map.bottomSheetHeight.value > SizeConfig.screenHeight) {
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value = SizeConfig.screenHeight;
            map.openedAddressSearch.value = true;
          } else if (map.bottomSheetDragOffset.value > 0 &&
              map.bottomSheetHeight.value > 230 &&
              !MapController.find.openedSelectCar.value) {
            //(SizeConfig.screenHeight
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value = SizeConfig.screenHeight;
            map.openedAddressSearch.value = true;
          } else if (map.bottomSheetDragOffset.value > 0 &&
              map.bottomSheetHeight.value < SizeConfig.screenHeight &&
              MapController.find.openedSelectCar.value) {
            //(SizeConfig.screenHeight
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value -= details.delta.dy;
          } else {
            map.bottomSheetDragOffset.value -= details.delta.dy;
            map.bottomSheetHeight.value -= details.delta.dy;
          }
        },
        onVerticalDragEnd: (details) {
          map.bottomSheetDragOffset.value = 0.0;
        },
        child: Container(
          width: double.maxFinite,
          height: map.bottomSheetHeight.value,
          padding: const EdgeInsets.all(AppSizes.padding * 1.4),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              )
            ],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(
                AppSizes.padding * 2,
              ),
            ),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Divider(
                color: AppColors.grey300,
                thickness: 3,
                endIndent: SizeConfig.screenWidth * 0.3,
                indent: SizeConfig.screenWidth * 0.3,
              ),
              const SizedBox(height: AppSizes.padding),
              !map.openedSelectCar.value
                  ? DriverRatingInformation(map: map)
                  : DriverOnTrip(map: map),
            ],
          ),
        ));
  }
}

class DriverRatingInformation extends StatelessWidget {
  const DriverRatingInformation({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();

    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  auth.userModel.value!.isOnline
                      ? 'You are now online'
                      : 'You are offline',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                wSizedBox2,
                SvgPicture.asset(
                  Assets.assetsImagesDriverIconOnlineSignalIcon,
                  height: AppSizes.iconSize,
                  color: auth.userModel.value!.isOnline
                      ? AppColors.green
                      : AppColors.red,
                ),
              ],
            ),
          ),
          hSizedBox4,
          const SizedBox(width: double.maxFinite),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.assetsImagesDriverIconAcceptanceIcon),
                  hSizedBox2,
                  Text(
                      "${auth.driverAcceptanceRate.value.toStringAsFixed(2)} %"),
                  hSizedBox2,
                  Text(
                    "Acceptance",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(
                height: 44 * 2,
                child: VerticalDivider(thickness: 2, width: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.assetsImagesDriverIconRatingIcon),
                  hSizedBox2,
                  Text("${auth.userRating.value.toStringAsFixed(2)} %"),
                  hSizedBox2,
                  Text(
                    "Rating",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(
                height: 44 * 2,
                child: VerticalDivider(thickness: 2, width: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      Assets.assetsImagesDriverIconCancellationIcon),
                  hSizedBox2,
                  Text(
                      "${auth.driverCancellationRate.value.toStringAsFixed(2)} %"),
                  hSizedBox2,
                  Text(
                    "Cancellation",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class DriverOnTrip extends StatelessWidget {
  const DriverOnTrip({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return DriverRatingInformation(map: map);
  }
}
