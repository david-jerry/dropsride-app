import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/widget/bottom_sheets/rider/driver.dart';
import 'package:dropsride/src/features/home/widget/bottom_sheets/rider/rider.dart';
import 'package:dropsride/src/features/home/widget/map/google_map.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:dropsride/src/features/transaction/view/subscription_screen.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // size config initialization
    SizeConfig.init(context);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    MapController map = Get.find<MapController>();
    AuthController auth = Get.find<AuthController>();

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
                  child: !auth.userModel.value!.isDriver
                      ? SearchLocationBottomSheet(
                          map: map,
                        )
                      : DriverBottomSheet(
                          map: map,
                        ), //map.dropOffSelected.value
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

                // ? Driver needs to come online first
                if (AuthController.find.userModel.value!.isDriver &&
                    !AuthController.find.userModel.value!.isOnline)
                  Positioned(
                    top: SizeConfig.screenHeight -
                        map.bottomSheetHeight.value +
                        10,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Image.asset(Assets.assetsImagesIconsAnimationRight, height: AppSizes.iconSize * 3.5),
                              Expanded(
                                child: Text(
                                  AuthController
                                          .find.userModel.value!.isSubscribed
                                      ? 'GO ONLINE'
                                      : "SUBSCRIBE TO DRIVE",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onPrimary
                                      ),
                                ),
                              ),
                              Image.asset(Assets.assetsImagesIconsAnimationRight, height: AppSizes.iconSize * 3.5),
                            ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
