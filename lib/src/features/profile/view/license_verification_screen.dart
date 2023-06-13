import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/license_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicenseVerificationScreen extends StatelessWidget {
  const LicenseVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Assets.assetsImagesDriverImagesLicenseFinished),
                Text(
                  'Thank You!',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                hSizedBox2,
                Text(
                  "Your data is being processed and you will enjoy all the features of the application upon verification",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                hSizedBox2,
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      LicenseController.instance.approved.value = 1;
                      LicenseController.instance.firstCapture.value = true;
                      Get.back();
                    },
                    child: Text(
                      'Continue',
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
      ),
    );
  }
}
