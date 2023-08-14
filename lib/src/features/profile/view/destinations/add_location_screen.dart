import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/controller/repository/places_autocomplete_repository.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddFavoriteScreen extends StatelessWidget {
  AddFavoriteScreen({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Get.put(DestinationRepository());
    TextEditingController addressController = TextEditingController();
    MapController map = Get.find<MapController>();
    return Scaffold(
      // ! app bar section
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Get.isDarkMode
            ? AppColors.backgroundColorDark
            : AppColors.backgroundColorLight,
        leading: IconButton(
          onPressed: () => Get.back(canPop: true, closeOverlays: false),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(pageTitle: "Add New Location"),
      ),

      body: Obx(
        () => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.9,
                  width: SizeConfig.screenWidth,
                  child: GoogleMap(
                    padding: EdgeInsets.only(
                        bottom: DestinationController
                            .instance.bottomSheetHeight.value * 0.7),
                    onTap: (value) {
                      FocusScope.of(context).unfocus();
                      DestinationController.instance.bottomSheetHeight.value =
                          SizeConfig.screenHeight * 0.4;
                    },
                    onMapCreated: DestinationController.instance.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: map.pickLocation.value,
                      zoom: 14.4746,
                    ),
                    myLocationEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: map.pickLocation.value,
                        icon: map.userIcon.value,
                        draggable: true,
                        anchor: const Offset(0.5, 0.5),
                        onDragEnd: (value) async {},
                      ),
                    },
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                ),
                Positioned(
                  top: SizeConfig.screenHeight -
                      DestinationController.instance.bottomSheetHeight.value +
                      20,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: GestureDetector(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      if (DestinationController
                                  .instance.bottomSheetDragOffset.value <
                              0 &&
                          DestinationController
                                  .instance.bottomSheetHeight.value <
                              (SizeConfig.screenHeight * 0.4)) {
                        DestinationController
                            .instance.bottomSheetDragOffset.value = 0.0;
                        DestinationController.instance.bottomSheetHeight.value =
                            (SizeConfig.screenHeight * 0.4);
                      } else if (DestinationController
                                  .instance.bottomSheetDragOffset.value >
                              0 &&
                          DestinationController
                                  .instance.bottomSheetHeight.value >=
                              (SizeConfig.screenHeight - 33)) {
                        DestinationController
                            .instance.bottomSheetDragOffset.value = 0.0;
                        DestinationController.instance.bottomSheetHeight.value =
                            SizeConfig.screenHeight - 33;
                      } else {
                        DestinationController.instance.bottomSheetDragOffset
                            .value -= details.delta.dy;
                        DestinationController.instance.bottomSheetHeight
                            .value -= details.delta.dy;
                      }
                    },
                    onVerticalDragEnd: (details) {
                      DestinationController
                          .instance.bottomSheetDragOffset.value = 0.0;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.padding * 1.4),
                      width: double.maxFinite,
                      height: DestinationController
                          .instance.bottomSheetHeight.value,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -3),
                          )
                        ],
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(
                            AppSizes.padding * 2,
                          ),
                        ),
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
                          Text(
                            'Address Details',
                            textAlign: TextAlign.center,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Theme.of(Get.context!)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          const Divider(
                            height: AppSizes.padding * 3,
                            thickness: 1.4,
                            color: AppColors.grey300,
                          ),
                          Obx(
                            () => Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        enableIMEPersonalizedLearning: true,
                                        onTapOutside: (event) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        onChanged: (value) =>
                                            DestinationController
                                                .instance.title.value = value,
                                        decoration: InputDecoration(
                                          label: const Text('Name'),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          isDense: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.margin,
                                            ),
                                            borderSide: const BorderSide(
                                                width: AppSizes.p2,
                                                color: AppColors.primaryColor),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.margin,
                                            ),
                                            borderSide: const BorderSide(
                                                width: AppSizes.p2,
                                                color: AppColors.red),
                                          ),
                                        ),
                                      ),
                                      hSizedBox2,
                                      TextFormField(
                                        controller: addressController,
                                        onChanged: (value) {
                                          DestinationController.instance
                                              .searchPlaces(value);
                                        },
                                        onTapOutside: (event) {
                                          formKey.currentState!.validate();
                                          FocusScope.of(context).unfocus();
                                        },
                                        enableIMEPersonalizedLearning: true,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "This field can not be null or empty";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(
                                              FontAwesomeIcons.location),
                                          label: const Text('Address'),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          isDense: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.margin,
                                            ),
                                            borderSide: const BorderSide(
                                                width: AppSizes.p2,
                                                color: AppColors.primaryColor),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.margin,
                                            ),
                                            borderSide: const BorderSide(
                                                width: AppSizes.p2,
                                                color: AppColors.red),
                                          ),
                                        ),
                                      ),
                                      hSizedBox2,
                                      PlacesAutocompleteRepository.instance
                                                  .jsonPredictions.length >
                                              1
                                          ? SizedBox(
                                              width: double.maxFinite,
                                              height: DestinationController
                                                      .instance
                                                      .bottomSheetHeight
                                                      .value *
                                                  0.2,
                                              child: ListView.builder(
                                                itemCount:
                                                    PlacesAutocompleteRepository
                                                        .instance
                                                        .jsonPredictions
                                                        .length,
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                  onTap: () async {
                                                    DestinationController
                                                            .instance
                                                            .currentAddress
                                                            .value =
                                                        PlacesAutocompleteRepository
                                                            .instance
                                                            .jsonPredictions[
                                                                index]
                                                            .description
                                                            .toString();

                                                    addressController.text =
                                                        PlacesAutocompleteRepository
                                                            .instance
                                                            .jsonPredictions[
                                                                index]
                                                            .description
                                                            .toString();

                                                    await DestinationController
                                                        .instance
                                                        .getCordinates();
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : hSizedBox2,
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            DestinationController.instance
                                                .createNewLocation(formKey);
                                          },
                                          child: Text(
                                            'Add New Address',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 17,
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
