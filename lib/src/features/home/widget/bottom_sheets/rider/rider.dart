import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/search_location_screen.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/features/profile/view/favorite_destinations.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/view/payment_method.dart';
import 'package:dropsride/src/features/trips/controller/repository/location_repository.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchLocationBottomSheet extends StatelessWidget {
  const SearchLocationBottomSheet({super.key, required this.map});

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (map.bottomSheetDragOffset.value < 0 &&
              map.bottomSheetHeight.value < 221) {
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value = 220.0;
          } else if (map.bottomSheetDragOffset.value > 0 &&
              map.bottomSheetHeight.value > SizeConfig.screenHeight) {
            map.bottomSheetDragOffset.value = 0.0;
            map.bottomSheetHeight.value = SizeConfig.screenHeight;
            map.openedAddressSearch.value = true;
          } else if (map.bottomSheetDragOffset.value > 0 &&
              map.bottomSheetHeight.value > 220 &&
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
                  ? ExpandAddressSearchWidget(map: map)
                  : SelectCarForTripWidget(map: map),
            ],
          ),
        ));
  }
}

class ExpandAddressSearchWidget extends StatelessWidget {
  const ExpandAddressSearchWidget({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ?trigger input for dropoff location search
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(AppSizes.padding),
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.secondaryColor),
                onTap: () {
                  Get.to(
                    () => const SearchLocationScreen(),
                    transition: Transition.downToUp,
                    duration: const Duration(
                      milliseconds: 800,
                    ),
                  );
                },
                onChanged: (value) {},
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  suffixIcon: Transform.scale(
                    scale: 0.6,
                    child: SvgPicture.asset(
                      Assets.assetsImagesIconsLocationFilled,
                      color: AppColors.grey300,
                      height: 10,
                      width: 10,
                    ),
                  ),
                  hintText: map.userDropOffLocation.value!.locationName ??
                      "Lets Go To?",
                  fillColor:
                      Get.isDarkMode ? AppColors.grey500 : AppColors.grey100,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // ? saved locations
            FutureBuilder<FavouriteDestination?>(
              future: DestinationRepository.instance.getSavedHomeDestination(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  map.home.value = data;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.homeAlt,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(
                          data.title!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => const FavoriteScreen());
                        },
                        leading: Icon(
                          FontAwesomeIcons.homeAlt,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        subtitle: Text(
                          "Save a home address",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                        ),
                        title: Text(
                          "Home",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<FavouriteDestination?>(
              future:
                  DestinationRepository.instance.getSavedSchoolDestination(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  map.school.value = data;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.school,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(
                          data.title!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => const FavoriteScreen());
                        },
                        leading: Icon(
                          FontAwesomeIcons.school,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        subtitle: Text(
                          "Save a school address",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                        ),
                        title: Text(
                          "School",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<FavouriteDestination?>(
              future: DestinationRepository.instance.getSavedWorkDestination(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  map.work.value = data;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.briefcase,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(
                          data.title!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => const FavoriteScreen());
                        },
                        leading: Icon(
                          FontAwesomeIcons.briefcase,
                          size: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.center,
                        subtitle: Text(
                          "Save a work address",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                        ),
                        title: Text(
                          "Work",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.grey300,
                        thickness: 2,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SelectCarForTripWidget extends StatelessWidget {
  const SelectCarForTripWidget({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.maxFinite,
        height: map.bottomSheetHeight.value - 90,
        child: SingleChildScrollView(
          child: map.openedSelectCar.value && !map.confirmTrip.value ||
                  map.openedSelectCar.value &&
                      map.confirmTrip.value &&
                      map.locationChanged.value
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                    Assets.assetsImagesIconsCurrentLocation,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(
                                    height: 37,
                                    child: VerticalDivider(
                                      width: AppSizes.p12,
                                      thickness: 2,
                                      indent: 8,
                                      endIndent: 8,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    Assets.assetsImagesIconsLocationFilled,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        map.userPickupLocation.value!
                                            .locationName!,
                                        softWrap: true,
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.3,
                                      height: AppSizes.padding * 2.4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        map.userDropOffLocation.value!
                                            .locationName!,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          hSizedBox4,
                          InkWell(
                            onTap: () {
                              Get.to(() => const PaymentMethod());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      Assets.assetsImagesIconsCash),
                                  wSizedBox4,
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.24,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          "Personal Trip",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(CardController
                                                  .instance
                                                  .paymentMethod
                                                  .value),
                                            ),
                                            Icon(
                                              FontAwesomeIcons.angleDown,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.7),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: map.carPricing.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              double amt = map.carPricing[index].amount ?? 0.0;
                              map.selectPickupCar(
                                  amt, map.carPricing[index].carType);
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.padding * 1.4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSizes.padding),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.assetsImagesPrivateRide,
                                      width: AppSizes.iconSize * 1.4,
                                    ),
                                    wSizedBox2,
                                    Expanded(
                                      child: Text(
                                        map.carPricing[index].carType?.name ??
                                            "car name",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                    wSizedBox2,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₦ ${map.carPricing[index].amount != null ? map.carPricing[index].amount!.toStringAsFixed(2) : 0.00}',
                                          style: GoogleFonts.inter(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.secondaryColor,
                                                ),
                                          ),
                                        ),
                                        Text(
                                            "${map.estimatedTripDistance.value.toStringAsFixed(2)} Km"
                                                .toString()),
                                      ],
                                    ),
                                    Obx(
                                      () => Radio(
                                        value: map.carPricing[index].amount,
                                        groupValue: map.estimatedTripCost.value,
                                        onChanged: (value) {
                                          map.selectPickupCar(value!,
                                              map.carPricing[index].carType);
                                        },
                                        activeColor: AppColors.primaryColor,
                                        overlayColor:
                                            const MaterialStatePropertyAll(
                                                AppColors.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : ConfirmingRideWidget(map: map),
        ),
      ),
    );
  }
}

class ConfirmingRideWidget extends StatelessWidget {
  const ConfirmingRideWidget({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      child: Column(
        children: [
          Obx(
            () => SizedBox(
              width: double.maxFinite,
              child: map.bookingConfirmed.value && !map.rideAccepted.value
                  ? Column(
                      children: [
                        Text(
                          'Confirm Pickup',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        hSizedBox2,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.p20),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.padding,
                                  horizontal: AppSizes.buttonHeight * 1.4,
                                ),
                              ),
                              onPressed: () async {},
                              child: Text(
                                map.vehicleType.value!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            wSizedBox4,
                            InkWell(
                              onTap: () {
                                map.dropOffSelected.value = true;
                                map.openedAddressSearch.value = false;
                                map.openedSelectCar.value = true;
                                map.confirmTrip.value = false;
                                map.bottomSheetHeight.value = 340;
                              },
                              child: SvgPicture.asset(
                                Assets.assetsImagesIconsEdit,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        hSizedBox4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              map.tripInfo.value!.duration_text != null
                                  ? map.tripInfo.value!.duration_text!
                                  : 'tripInfo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            Text(
                              '${map.getCurrency('NGN')}${map.estimatedTripCost.value.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryColor,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // divider
                        const Divider(
                            thickness: 3, height: AppSizes.padding * 2),

                        Row(
                          children: [
                            SvgPicture.asset(
                                Assets.assetsImagesDriverIconPickupIndicator),
                            wSizedBox2,
                            Expanded(
                              child: Text(
                                '${map.userPickupLocation.value!.locationName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryColor,
                                      ),
                                ),
                              ),
                            ),
                            wSizedBox6,
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => const SearchLocationScreen(),
                                  transition: Transition.downToUp,
                                  duration: const Duration(
                                    milliseconds: 1200,
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                Assets.assetsImagesIconsEdit,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        hSizedBox4,
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              foregroundColor: AppColors.white100,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.p20),
                              ),
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.buttonHeight / 3.4,
                                horizontal: AppSizes.buttonHeight * 1.4,
                              ),
                            ),
                            onPressed: () async {
                              LocationRepository.instance.saveTripRequest();
                            },
                            child: Text(
                              "Confirm",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    map.bookingConfirmed.value &&
                                            map.rideAccepted.value &&
                                            !map.showSelectedDriver.value
                                        ? 'Booking Confirmed'
                                        : "Arriving in ${map.driverArrivalTime.value}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    map.bookingConfirmed.value &&
                                            map.rideAccepted.value &&
                                            !map.showSelectedDriver.value
                                        ? 'Drops has accepted your booking, we are looking for a driver for you.'
                                        : "${map.carName.value}, ${map.carColor.value}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                )
                              ]),
                            ),
                            if (map.bookingConfirmed.value &&
                                map.rideAccepted.value &&
                                map.showSelectedDriver.value)
                              OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                  map.plateNumber.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      hSizedBox2,
                      map.bookingConfirmed.value &&
                              map.rideAccepted.value &&
                              !map.showSelectedDriver.value
                          ? LinearProgressIndicator(
                              minHeight: AppSizes.p14,
                              value: map.progressbarValue.value,
                              backgroundColor: AppColors.grey200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.network(
                                              map.driverPhoto.value,
                                              fit: BoxFit.cover,
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: SvgPicture.asset(Assets
                                                .assetsImagesDriverIconVerifiedIcon),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      map.name.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.iconSize * 2.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.iconSize * 2.5),
                                        color: AppColors.primaryColor,
                                      ),
                                      padding: const EdgeInsets.all(
                                          AppSizes.padding),
                                      child: const Icon(
                                          FontAwesomeIcons.message,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.iconSize * 2.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.iconSize * 2.5),
                                        color: AppColors.green,
                                      ),
                                      padding: const EdgeInsets.all(
                                          AppSizes.padding),
                                      child: const Icon(
                                          FontAwesomeIcons.squarePhone,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.iconSize * 2.5),
                                        color: AppColors.grey300,
                                      ),
                                      padding: const EdgeInsets.all(
                                          AppSizes.padding),
                                      child: const Icon(FontAwesomeIcons.shield,
                                          color: AppColors.secondaryColor),
                                    ),
                                    Text(
                                      'Safety',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      hSizedBox4,
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.assetsImagesIconsLocation),
                            wSizedBox2,
                            Text(
                              map.userDropOffLocation.value!.locationName ??
                                  "No dropoff",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      hSizedBox2,
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.p40),
                            ),
                            foregroundColor: AppColors.whiteColor,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.padding,
                              horizontal: AppSizes.buttonHeight * 1.4,
                            ),
                          ),
                          onPressed: () async {
                            map.cancelRideRequesting();
                          },
                          child: Text(
                            "Cancel Trip",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.red,
                                ),
                          ),
                        ),
                      )
                    ]),
            ),
          )
        ],
      ),
    );
  }
}
