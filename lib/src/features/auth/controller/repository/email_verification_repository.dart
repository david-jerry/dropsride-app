import 'dart:async';

import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/widgets/bottom_sheet/email_verification_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationRepository extends GetxController {
  static EmailVerificationRepository get instance => Get.find();

  Future<void> sendVerification(User user) async {
    if (!user.emailVerified) {
      // send verification email
      if (AuthenticationRepository.instance.count > 0) {
        await user.sendEmailVerification();
        AuthenticationRepository.instance.count--;
      }

      // show bottom sheet if user email is unverified
      Get.bottomSheet(
        backgroundColor: Theme.of(Get.context!).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.padding),
        ),
        AwaitingEmailVerification(
          user: user,
        ),
      );
    }
  }
}
