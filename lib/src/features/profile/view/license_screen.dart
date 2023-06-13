import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/license_controller.dart';
import 'package:dropsride/src/features/profile/view/license_verification_screen.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DriversLicenseScreen extends StatelessWidget {
  const DriversLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              LicenseController.instance.firstCapture.value
                  ? Get.back(canPop: true, closeOverlays: false)
                  : LicenseController.instance.firstCapture.value = true;
            },
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          titleSpacing: AppSizes.padding,
          primary: true,
          scrolledUnderElevation: AppSizes.p4,
          title: const AppBarTitle(pageTitle: "Drivers License"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding * 1.6),
            child: LicenseController.instance.firstCapture.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hSizedBox2,
                      Center(
                        child: LicenseController.instance.imagePreview.value !=
                                null
                            ? Image.file(
                                LicenseController.instance.imagePreview.value!)
                            : Image.asset(Assets
                                .assetsImagesDriverImagesLicenseSampleHolding),
                      ),
                      hSizedBox6,
                      Text(
                        'Take a picture of you holding your license like this',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      hSizedBox6,
                      OutlinedButton(
                        onPressed: () {
                          LicenseController.instance.firstCapture.value = false;
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24))),
                          backgroundColor: MaterialStateProperty.all(
                              Get.isDarkMode
                                  ? AppColors.backgroundColorDark
                                  : AppColors.backgroundColorLight),
                          elevation: MaterialStateProperty.all(4),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Next Step Upload your license',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
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
                          onPressed: () {
                            LicenseController.instance
                                .takeLicenseOwnerPicture();
                          },
                          child: Text(
                            'Take Shot',
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
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hSizedBox2,
                      Center(
                        child: LicenseController
                                    .instance.imageLicensePreview.value !=
                                null
                            ? Image.file(LicenseController
                                .instance.imageLicensePreview.value!)
                            : Image.asset(
                                Assets.assetsImagesDriverImagesLicensePhoto),
                      ),
                      hSizedBox6,
                      Text(
                        'Take a picture of your license like this without any obstruction',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      hSizedBox6,
                      OutlinedButton(
                        onPressed: () {
                          LicenseController.instance.approved.value < 2
                              ? Get.to(() => const LicenseVerificationScreen())
                              : null;
                          LicenseController.instance.approved.value = 2;
                          LicenseController.instance.updateLicensePhoto(
                              LicenseController.instance.imagePreview.value,
                              LicenseController
                                  .instance.imageLicensePreview.value);
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24))),
                          backgroundColor: MaterialStateProperty.all(
                              Get.isDarkMode
                                  ? AppColors.backgroundColorDark
                                  : AppColors.backgroundColorLight),
                          elevation: MaterialStateProperty.all(4),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Next Step Await Verification',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
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
                          onPressed: () {
                            LicenseController.instance.takeLicensePicture();
                          },
                          child: Text(
                            'Take Shot',
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
    );
  }
}
