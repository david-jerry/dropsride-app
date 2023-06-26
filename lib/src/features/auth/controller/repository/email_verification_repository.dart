import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerificationRepository extends GetxController {
  static EmailVerificationRepository get instance => Get.find();

  Future<void> sendVerification(User user) async {
    if (!user.emailVerified) {
      // send verification email
      await user.sendEmailVerification();
    }
  }
}
