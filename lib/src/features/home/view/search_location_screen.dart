import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/places_autocomplete_repository.dart';
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
        () => SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ? Custom App Bar
                  AppBar(
                    automaticallyImplyLeading: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    leading: IconButton(
                      onPressed: () async {
                        Get.back(canPop: true, closeOverlays: false);
                        map.openedAddressSearch.value = false;
                        map.openedSelectCar.value = false;
                        map.bottomSheetHeight.value = 220;
                      },
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

                    // ? the header pickup and dropoff location textfield
                    child: Row(
                      children: [
                        // ? the icons on the left
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

                        // ? the text fields on the right
                        Expanded(
                          child: Column(
                            children: [
                              // ? pickup text field
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

                              // ? dropoff text field and trigger the auto complete places
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
                                  onChanged: (value) {
                                    DestinationController.instance
                                        .searchPlaces(value);
                                  },
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
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
                            // ? saved locationes
                            if (map.home.value != null)
                              Column(
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
                                      map.home.value!.title,
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
                              ),
                            if (map.school.value != null)
                              Column(
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
                                      map.school.value!.title,
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
                              ),
                            if (map.work.value != null)
                              Column(
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
                                      map.work.value!.title,
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
                              ),

                            // ? places auto complete
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
                                                FocusScope.of(context)
                                                    .unfocus();
                                                map.dropOffFieldEditingController
                                                        .text =
                                                    PlacesAutocompleteRepository
                                                        .instance
                                                        .jsonPredictions[index]
                                                        .description
                                                        .toString();

                                                await map.getDropoffAddressFromText(
                                                    MapController
                                                        .find
                                                        .dropOffFieldEditingController
                                                        .text);

                                                map.dropOffSelected.value =
                                                    true;
                                                map.openedAddressSearch.value =
                                                    false;
                                                map.openedSelectCar.value =
                                                    true;
                                                map.bottomSheetHeight.value =
                                                    340;

                                                await map.getPolyPoints(
                                                    map.userPickupLocation
                                                        .value!,
                                                    map.userDropOffLocation
                                                        .value!);

                                                Get.back(canPop: true);
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
      ),
    );
  }
}
