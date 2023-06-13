import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/controller/repository/places_autocomplete_repository.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

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

      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Obx(
              () => Positioned(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight * 0.95,
                top: 0,
                child: GoogleMap(
                  onTap: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  onMapCreated: DestinationController.instance.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: map.pickLocation.value,
                    zoom: 14.4746,
                  ),
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                ),
              ),
            ),
            SlidingUpPanel(
              color: ThemeModeController.instance.isDarkMode.value
                  ? AppColors.backgroundColorDark
                  : AppColors.backgroundColorLight,
              snapPoint: .5,
              disableDraggableOnScrolling: false,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                  AppSizes.padding * 2,
                ),
              ),
              panelBuilder: () {
                return Container(
                  padding: const EdgeInsets.all(AppSizes.padding * 2),
                  child: Column(
                    children: [
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
                      Divider(
                        height: AppSizes.padding * 3,
                        thickness: 1.4,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Obx(
                        () => Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                enableIMEPersonalizedLearning: true,
                                onChanged: (value) => DestinationController
                                    .instance.title.value = value,
                                decoration: InputDecoration(
                                  label: const Text('Name'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.onSecondary,
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
                                },
                                enableIMEPersonalizedLearning: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "This field can not be null or empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon:
                                      const Icon(FontAwesomeIcons.location),
                                  label: const Text('Address'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.onSecondary,
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
                              PlacesAutocompleteRepository
                                          .instance.jsonPredictions.length >
                                      1
                                  ? SizedBox(
                                      width: double.maxFinite,
                                      height: AppSizes.margin * 20,
                                      child: ListView.builder(
                                        itemCount: PlacesAutocompleteRepository
                                            .instance.jsonPredictions.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          onTap: () async {
                                            DestinationController.instance
                                                    .currentAddress.value =
                                                PlacesAutocompleteRepository
                                                    .instance
                                                    .jsonPredictions[index]
                                                    .description
                                                    .toString();

                                            addressController.text =
                                                PlacesAutocompleteRepository
                                                    .instance
                                                    .jsonPredictions[index]
                                                    .description
                                                    .toString();

                                            await DestinationController.instance
                                                .getCordinates();
                                          },
                                          dense: true,
                                          leading: const Icon(
                                              FontAwesomeIcons.mapPin),
                                          contentPadding: const EdgeInsets.all(
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
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
