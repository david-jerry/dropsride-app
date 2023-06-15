import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/controller/repository/places_autocomplete_repository.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SearchLocationScreen extends StatelessWidget {
  const SearchLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MapController map = Get.find<MapController>();
    return Scaffold(
      body: Obx(
        () => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ? Custom App Bar
                AppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () =>
                        Get.back(canPop: true, closeOverlays: false),
                    icon: Icon(
                      FontAwesomeIcons.close,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  titleSpacing: AppSizes.padding,
                  primary: true,
                  scrolledUnderElevation: AppSizes.p4,
                  title: const AppBarTitle(pageTitle: "Select Destinations"),
                ),

                // ? Location form
                Padding(
                  padding: const EdgeInsets.all(AppSizes.padding * 1.4),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            Assets.assetsImagesIconsCurrentLocation,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(
                            height: 45,
                            child: VerticalDivider(
                              width: AppSizes.p12,
                              thickness: 2,
                              indent: 8,
                              endIndent: 8,
                            ),
                          ),
                          SvgPicture.asset(
                            Assets.assetsImagesIconsLocationFilled,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      wSizedBox2,
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(AppSizes.padding),
                              ),
                              width: double.maxFinite,
                              child: TextField(
                                // onTap: () {
                                //   map.bottomSheetHeight.value =
                                //       SizeConfig.screenHeight;
                                // },
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                enableSuggestions: true,
                                onChanged: (value) {},
                                controller: MapController
                                    .find.pickUpFieldEditingController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  filled: true,
                                  isDense: true,
                                  suffixIcon: Transform.scale(
                                    scale: 0.6,
                                    child: SvgPicture.asset(
                                      Assets.assetsImagesIconsCurrentLocation,
                                      color: AppColors.grey300,
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                                  hintText: map.userPickupLocation.value!
                                              .locationName !=
                                          null
                                      ? map.userPickupLocation.value!
                                          .locationName!
                                      : "Pickup Location",
                                  fillColor: AppColors.grey100,
                                ),
                              ),
                            ),
                            hSizedBox2,
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(AppSizes.padding),
                              ),
                              child: TextField(
                                // onTap: () {
                                //   map.bottomSheetHeight.value =
                                //       SizeConfig.screenHeight;
                                // },
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: (value) {
                                  DestinationController.instance
                                      .searchPlaces(value);
                                },
                                controller: MapController
                                    .find.dropOffFieldEditingController,
                                keyboardType: TextInputType.streetAddress,
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
                                  hintText: map.bottomSheetHeight.value < 250
                                      ? "Lets Go To?"
                                      : "Destination",
                                  fillColor: AppColors.grey100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                  color: AppColors.grey200,
                ),

                // ? Places suggestions and Saved Destinations
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.padding * 0.5,
                      horizontal: AppSizes.padding * 1.4),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: (SizeConfig.screenHeight * 0.65) - 18,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          StreamBuilder<FavouriteDestination>(
                            stream: DestinationRepository.instance
                                .getSavedHomeDestination(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        FontAwesomeIcons.homeAlt,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      dense: true,
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      title: Text(
                                        data.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
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
                                return Visibility(
                                  visible: false,
                                  child: ListTile(
                                    leading: Icon(
                                      FontAwesomeIcons.homeAlt,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    dense: true,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Text(
                                      'Home',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          StreamBuilder<FavouriteDestination>(
                            stream: DestinationRepository.instance
                                .getSavedSchoolDestination(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        FontAwesomeIcons.school,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      dense: true,
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      title: Text(
                                        data.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
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
                                return Visibility(
                                  visible: false,
                                  child: ListTile(
                                    leading: Icon(
                                      FontAwesomeIcons.homeAlt,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    dense: true,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Text(
                                      'Home',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          StreamBuilder<FavouriteDestination>(
                            stream: DestinationRepository.instance
                                .getSavedWorkDestination(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        FontAwesomeIcons.briefcase,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      dense: true,
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      title: Text(
                                        data.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
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
                                return Visibility(
                                  visible: false,
                                  child: ListTile(
                                    leading: Icon(
                                      FontAwesomeIcons.briefcase,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    dense: true,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Text(
                                      'Work',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          PlacesAutocompleteRepository
                                      .instance.jsonPredictions.length >
                                  1
                              ? SizedBox(
                                  width: double.maxFinite,
                                  height: SizeConfig.screenHeight * 0.5,
                                  child: ListView.builder(
                                    itemCount: PlacesAutocompleteRepository
                                        .instance.jsonPredictions.length,
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppSizes.padding),
                                          child: ListTile(
                                            onTap: () async {
                                              MapController
                                                      .find
                                                      .dropOffFieldEditingController
                                                      .text =
                                                  PlacesAutocompleteRepository
                                                      .instance
                                                      .jsonPredictions[index]
                                                      .description
                                                      .toString();

                                              MapController.find
                                                  .getDropoffAddressFromText(
                                                      MapController
                                                          .find
                                                          .dropOffFieldEditingController
                                                          .text);
                                            },
                                            dense: true,
                                            leading: const Icon(
                                                FontAwesomeIcons.mapPin),
                                            contentPadding:
                                                const EdgeInsets.all(
                                              AppSizes.padding / 6,
                                            ),
                                            title: Text(
                                              PlacesAutocompleteRepository
                                                  .instance
                                                  .jsonPredictions[index]
                                                  .description
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          color: AppColors.grey300,
                                          thickness: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Visibility(visible: false, child: hSizedBox2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
