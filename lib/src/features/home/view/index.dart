import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:dropsride/src/features/profile/controller/bank_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42709442432, -122.0847794389585),
    zoom: 14.4746,
  );

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                        map.controllerGoogleMap.value.complete(controller);
                        map.newGoogleMapController.value = controller;
                        map.locateUserPosition();
                      },
                      initialCameraPosition: CameraPosition(
                        target: map.pickLocation.value,
                        zoom: 15.4746,
                      ),
                      onCameraMove: (CameraPosition? position) {
                        if (map.pickLocation.value != position!.target) {
                          map.pickLocation.value = position.target;
                        }
                      },
                      onCameraIdle: () async {
                        await map.getAddressFromLatLng();
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      polylines: map.polylineSet,
                      markers: map.markerSet,
                      circles: map.circleSet,
                      mapType: MapType.normal,
                    ),
                  ),
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.screenHeight * 0.442,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Assets.assetsVideosPulsingAnimation,
                            gaplessPlayback: true,
                            fit: BoxFit.fill,
                            width: 65,
                            height: 65,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              map.userPhoto.value,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
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
      ),
    );
  }
}
