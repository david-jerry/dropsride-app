import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwaitingEmailVerification extends StatelessWidget {
  AwaitingEmailVerification({
    super.key,
    required this.user,
  });

  User user;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            hSizedBox4,
            Text(
              'Verification Processing?',
              style: Theme.of(Get.context!).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(Get.context!).colorScheme.onBackground,
                  ),
            ),
            hSizedBox2,
            Text(
              'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
              style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 16.0),
            Visibility(
              visible: !user.emailVerified ? true : false,
              child: const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16.0),
            // Divider(
            //   height: AppSizes.p18 * 2.8,
            //   color: Theme.of(Get.context!).colorScheme.onBackground,
            // ),
            // CustomButtons(
            //     ontap: () {
            //       Get.back();
            //     },
            //     icon: Icons.email_rounded,
            //     title: "Cancel",
            //     description: "Reset via email verification"),
          ],
        ));
  }
}
