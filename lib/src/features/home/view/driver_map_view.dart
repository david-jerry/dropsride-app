import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:dropsride/src/features/transaction/view/subscription_screen.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverAcceptedRideScreen extends StatelessWidget {
  const DriverAcceptedRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: const Center(
                      child: Text(
                          "Bottom Sheet Center")), //map.dropOffSelected.value
                ),

                // ? Driver needs to come online first
                if (AuthController.find.userModel.value!.isDriver &&
                    !AuthController.find.userModel.value!.isOnline)
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    color: AppColors.backgroundColorDark.withOpacity(0.8),
                    padding: const EdgeInsets.all(AppSizes.padding * 1.4),
                    child: Center(
                        child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        child: Text(
                          AuthController.find.userModel.value!.isSubscribed
                              ? 'GO ONLINE'
                              : "SUBSCRIBE TO DRIVE",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                        ),
                        onPressed: () {
                          AuthController.find.userModel.value!.isSubscribed
                              ? AuthController.find
                                  .comeOnline(AuthController.find.user.value)
                                  .then((value) => AssistantMethods
                                      .updateUserLocationRealTime())
                              : Get.to(() => const SubscriptionScreen());
                        },
                      ),
                    )),
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

                // ? Go Offline Button
                if (AuthController.find.userModel.value!.isDriver &&
                    AuthController.find.userModel.value!.isOnline)
                  Positioned(
                    top: AppSizes.padding * 3,
                    right: AppSizes.padding * 1.4,
                    child: GestureDetector(
                      onTap: () => AuthController.find
                          .driverGoOffline(AuthController.find.user.value),
                      child: Material(
                        elevation: 4,
                        borderRadius:
                            BorderRadius.circular(AppSizes.iconSize * 2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.iconSize * 2.5),
                            color: AppColors.red,
                          ),
                          padding: const EdgeInsets.all(AppSizes.padding),
                          child: const Icon(FontAwesomeIcons.powerOff),
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
