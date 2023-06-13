import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/vehicle/controller/vehicle_controller.dart';
import 'package:dropsride/src/features/vehicle/view/vehicle/vehicle_papers.dart';
import 'package:dropsride/src/features/vehicle/view/vehicle/vehicle_photos.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Get.offAll(() => const HomeScreen()),
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          titleSpacing: AppSizes.padding,
          primary: true,
          scrolledUnderElevation: AppSizes.p4,
          title: const AppBarTitle(
            pageTitle: "Vehicle",
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding * 1.4),
            child: Form(
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.to(() => const VehiclePhotoScreen());
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                      backgroundColor: MaterialStateProperty.all(Get.isDarkMode
                          ? AppColors.backgroundColorDark
                          : AppColors.backgroundColorLight),
                      elevation: MaterialStateProperty.all(4),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle Photos',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        const Icon(FontAwesomeIcons.angleRight)
                      ],
                    ),
                  ),
                  hSizedBox2,
                  TextFormField(
                    onTapOutside: (event) {},
                    onChanged: (value) {},
                    onSaved: (newValue) {},
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableIMEPersonalizedLearning: true,
                    decoration: InputDecoration(
                      label: const Text('Model'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSecondary,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.red),
                      ),
                    ),
                  ),
                  hSizedBox2,
                  TextFormField(
                    onTapOutside: (event) {},
                    onChanged: (value) {},
                    onSaved: (newValue) {},
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableIMEPersonalizedLearning: true,
                    decoration: InputDecoration(
                      label: const Text('Color'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSecondary,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.red),
                      ),
                    ),
                  ),
                  hSizedBox2,
                  TextFormField(
                    onTapOutside: (event) {},
                    onChanged: (value) {},
                    onSaved: (newValue) {},
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableIMEPersonalizedLearning: true,
                    decoration: InputDecoration(
                      label: const Text('Plate Number'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSecondary,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.red),
                      ),
                    ),
                  ),
                  hSizedBox2,
                  OutlinedButton(
                    onPressed: () {
                      Get.to(() => const VehiclePaperScreen());
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                      backgroundColor: MaterialStateProperty.all(Get.isDarkMode
                          ? AppColors.backgroundColorDark
                          : AppColors.backgroundColorLight),
                      elevation: MaterialStateProperty.all(4),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle Papers',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        const Icon(FontAwesomeIcons.angleRight)
                      ],
                    ),
                  ),
                  hSizedBox2,
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        final imageUrls = await VehicleController.instance
                            .updateVehiclePapers();
                        VehicleController.instance.saveVehiclePapers(imageUrls);
                      },
                      child: Text(
                        'Submit Details',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
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
        ));
  }
}
