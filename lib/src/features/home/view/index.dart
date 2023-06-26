import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/search_location_screen.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/features/profile/view/favorite_destinations.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/view/payment_method.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // size config initialization
    SizeConfig.init(context);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    MapController map = Get.find<MapController>();

    void openDrawer() {
      scaffoldKey.currentState?.openDrawer();
    }

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
                  child: GoogleMapWidget(map: map),
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
                  bottom: map.bottomSheetHeight.value + AppSizes.margin * 0.5,
                  left: AppSizes.padding,
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

                // ? Bottom Sheet with text field to add a dropoff location
                Positioned(
                  top: SizeConfig.screenHeight -
                      map.bottomSheetHeight.value +
                      20,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SearchLocationBottomSheet(
                    map: map,
                  ), //map.dropOffSelected.value
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget>
    with
        AutomaticKeepAliveClientMixin<GoogleMapWidget>,
        SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  AnimationController? _animationController;
  final CircleId _circleId = const CircleId('picker_circle');
  Animation<double>? _animation;
  final double _circleRadius = 100.0;
  final double _maxCircleRadius = 200.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: _circleRadius, end: _maxCircleRadius)
        .animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(
      () => Stack(
        children: [
          GoogleMap(
            padding:
                EdgeInsets.only(bottom: widget.map.bottomSheetHeight.value),
            buildingsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              if (!widget.map.controllerGoogleMap.value.isCompleted) {
                widget.map.controllerGoogleMap.value.complete(controller);
              }
              widget.map.newGoogleMapController.value = controller;
              if (!widget.map.pickupSelected.value) {
                widget.map.locateUserPosition();
                widget.map.circles.add(
                  Circle(
                    circleId: _circleId,
                    center: widget.map.pickLocation.value,
                    radius: _animation!.value,
                    fillColor: AppColors.primaryColor.withOpacity(0.4),
                    strokeColor: AppColors.primaryColor,
                    strokeWidth: 2,
                  ),
                );
              }
            },
            onTap: (LatLng latlng) {
              widget.map.bottomSheetHeight.value = 220;
              widget.map.pickLocation.value = latlng;
              widget.map.cameraPositionDefault.value = CameraPosition(
                target: latlng,
                zoom: 17.765,
                tilt: 0.3,
              );
              widget.map.newGoogleMapController.value!.animateCamera(
                  CameraUpdate.newCameraPosition(
                      widget.map.cameraPositionDefault.value));
            },
            initialCameraPosition: widget.map.cameraPositionDefault.value,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: widget.map.pLineCoordinatedList.toList(),
                color: AppColors.secondaryColor,
                width: 6,
              ),
            }, // Set<Polyline>.of(widget.map.polylineSet),
            markers: Set<Marker>.of(widget.map.markers),
            circles: Set<Circle>.of(widget.map.circles),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
        ],
      ),
    );
  }
}

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
                  // map.openedAddressSearch.value = true;
                  // map.openedSelectCar.value = false;
                  // map.bottomSheetHeight.value =
                  //     map.bottomSheetHeight.value = SizeConfig.screenHeight;
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
                          data.title,
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
                          data.title,
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
                          data.title,
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
          child: Column(
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                  map.userPickupLocation.value!.locationName!,
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
                                  map.userDropOffLocation.value!.locationName!,
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
                            SvgPicture.asset(Assets.assetsImagesIconsCash),
                            wSizedBox4,
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .instance.paymentMethod.value),
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
                  itemCount: map.carTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    double newAmount = map.carTypes[index].pricePerKm *
                            map.estimatedTripDistance.value +
                        map.carTypes[index].pricePerMinute *
                            map.estimatedArrivalTime.value;
                    map.updateAmount(newAmount);

                    if (map.carTypes[index].name != 'Unassigned') {
                      return InkWell(
                        onTap: () {
                          double amt = map.carTypes[index].baseFare + map.carTypes[index].pricePerKm *
                                  map.estimatedTripDistance.value +
                              map.carTypes[index].pricePerMinute *
                                  map.estimatedArrivalTime.value;
                          map.selectPickupCar(amt, map.carTypes[index]);
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.padding * 1.4),
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
                                    map.carTypes[index].name,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₦ ${map.amount.value.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondaryColor,
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
                                    value: map.carTypes[index].baseFare + map.carTypes[index].pricePerKm *
                                            map.estimatedTripDistance.value +
                                        map.carTypes[index].pricePerMinute *
                                            map.estimatedArrivalTime.value,
                                    groupValue: map.estimatedTripCost.value,
                                    onChanged: (value) {
                                      map.selectPickupCar(
                                          value!, map.carTypes[index]);
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
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
