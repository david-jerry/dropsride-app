import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/search_location_screen.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:dropsride/src/features/profile/controller/bank_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // size config initialization
    SizeConfig.init(context);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    BankController.instance.fetchBanks();

    MapController map = Get.find<MapController>();

    void openDrawer() {
      scaffoldKey.currentState?.openDrawer();
    }

    final isSubscribed = AuthController.instance.isSubscribed.value;

    return Scaffold(
      key: scaffoldKey,
      drawer: const SideBar(),
      body: Obx(
        () => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) async {
                      print('onMapCreated function running.');
                      if (!map.controllerGoogleMap.value.isCompleted) {
                        map.controllerGoogleMap.value.complete(controller);
                      } else {
                        print('map completer already complete.');
                      }
                      map.newGoogleMapController.value = controller;
                      map.locateUserPosition();
                    },
                    onTap: (LatLng latlng) {
                      FocusScope.of(context).unfocus();
                      map.bottomSheetHeight.value = 220;
                    },
                    initialCameraPosition: map.cameraPositionDefault.value,
                    onCameraMove: (CameraPosition? position) {
                      if (map.pickLocation.value != position!.target) {
                        map.pickLocation.value = position.target;
                      }
                    },
                    onCameraIdle: () async {
                      await map.getAddressFromLatLng();
                    },
                    myLocationEnabled: false,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    polylines: map.polylineSet,
                    markers: map.markerSet,
                    circles: map.circleSet,
                    mapType: MapType.normal,
                  ),
                ),

                // ? Menu Drawer Button
                Positioned(
                  top: AppSizes.padding * 3,
                  left: AppSizes.padding * 1.4,
                  child: GestureDetector(
                    onTap: () => openDrawer(),
                    child: Material(
                      elevation: 4,
                      borderRadius:
                          BorderRadius.circular(AppSizes.iconSize * 2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.iconSize * 2.5),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        padding: const EdgeInsets.all(AppSizes.padding),
                        child: SvgPicture.asset(
                          Assets.assetsImagesIconsMenuIcon,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),

                // ? Get Current Location Position FLoating Button
                Positioned(
                  bottom: map.bottomSheetHeight.value +
                      AppSizes.margin +
                      (AppSizes.padding * 3),
                  right: AppSizes.padding * 1.4,
                  child: GestureDetector(
                    onTap: () => map.goToMyLocation(),
                    child: Material(
                      elevation: 4,
                      borderRadius:
                          BorderRadius.circular(AppSizes.iconSize * 2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.iconSize * 2.5),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        padding: const EdgeInsets.all(AppSizes.padding),
                        child: SvgPicture.asset(
                          Assets.assetsImagesIconsCurrentLocation,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),

                // Align(
                //   alignment: Alignment.center,
                //   child: Padding(
                //     padding:
                //         EdgeInsets.only(top: SizeConfig.screenHeight * 0.442, left: 9.2),
                //     child: SvgPicture.asset(
                //       Assets.assetsImagesIconsUserMarker,
                //       height: 65,
                //       width: 65,
                //     ),
                //   ),
                // ),

                // ? Current Location Marker
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.screenHeight * 0.48,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset(Assets.assetsVideosPulsingJsonAnimation,
                            // Specify the width and height of the Lottie widget as per your needs
                            width: 40,
                            height: 40,
                            repeat: true,
                            fit: BoxFit.fill),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.network(
                            map.userPhoto.value,
                            fit: BoxFit.cover,
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Positioned(
                //   top: (AppSizes.padding * 3),
                //   left: (AppSizes.iconSize * 2.5) + AppSizes.padding + 20,
                //   right: 20,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Theme.of(context).colorScheme.onBackground,
                //       ),
                //       borderRadius:
                //           BorderRadius.circular(AppSizes.padding * 1.6),
                //       color: Theme.of(context).colorScheme.background,
                //     ),
                //     padding: const EdgeInsets.all(AppSizes.padding),
                //     child: Text(
                //       map.userPickupLocation.value!.locationName != null
                //           ? map.userPickupLocation.value!.locationName!
                //           : "Not Getting Address",
                //       overflow: TextOverflow.ellipsis,
                //       softWrap: true,
                //     ),
                //   ),
                // ),

                // ? Bottom Sheet with text field to add a dropoff location
                Positioned(
                  top: SizeConfig.screenHeight -
                      map.bottomSheetHeight.value +
                      20,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      if (map.bottomSheetDragOffset.value < 0 &&
                          map.bottomSheetHeight.value < 221) {
                        map.bottomSheetDragOffset.value = 0.0;
                        map.bottomSheetHeight.value = 220.0;
                      } else if (map.bottomSheetDragOffset.value > 0 &&
                          map.bottomSheetHeight.value >=
                              (SizeConfig.screenHeight - 33)) {
                        map.bottomSheetDragOffset.value = 0.0;
                        map.bottomSheetHeight.value =
                            SizeConfig.screenHeight - 33;
                      } else {
                        map.bottomSheetDragOffset.value -= details.delta.dy;
                        map.bottomSheetHeight.value -= details.delta.dy;
                      }

                      print(
                          "BottomSheet Height: ${map.bottomSheetHeight.value}");
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
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
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
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.padding),
                                    ),
                                    child: TextField(
                                      onTap: () {
                                        Get.to(
                                            () => const SearchLocationScreen());
                                      },
                                      onChanged: (value) {},
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        suffixIcon: Transform.scale(
                                          scale: 0.6,
                                          child: SvgPicture.asset(
                                            Assets
                                                .assetsImagesIconsLocationFilled,
                                            color: AppColors.grey300,
                                            height: 10,
                                            width: 10,
                                          ),
                                        ),
                                        hintText:
                                            map.userDropOffLocation.value!
                                              .locationName != null
                                                ? map.userDropOffLocation.value!
                                              .locationName : "Lets Go To?"
                                                ,
                                        fillColor: AppColors.grey100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  StreamBuilder<FavouriteDestination>(
                                    stream: DestinationRepository.instance
                                        .getSavedHomeDestination(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
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
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                          child: CircularProgressIndicator
                                              .adaptive(),
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
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                          child: CircularProgressIndicator
                                              .adaptive(),
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
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                ],
                              ),
                            ),
                          ),
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
