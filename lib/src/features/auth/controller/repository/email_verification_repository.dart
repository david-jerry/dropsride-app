import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerificationRepository extends GetxController {
  static EmailVerificationRepository get instance => Get.find();

  Future<void> sendVerification(User user) async {
    if (!user.emailVerified) {
      // send verification email
      await user.sendEmailVerification();

      // show bottom sheet if user email is unverified
      // Get.bottomSheet(
      //   backgroundColor: Theme.of(Get.context!).colorScheme.secondaryContainer,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppSizes.padding),
      //   ),
      //   AwaitingEmailVerification(
      //     user: user,
      //   ),
      // );
    }
  }
}
