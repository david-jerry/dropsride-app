import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/view/otp.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class PasswordResetRepository extends AuthenticationRepository {
  static PasswordResetRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxString _verificationCode = ''.obs;

  final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    url:
        'https://dropsride.page.link/reset-password/', // Update with your app's dynamic link domain
    androidPackageName:
        'com.dropsride.android', // Update with your app's package name
    iOSBundleId: 'com.dropsride.apple', // Update with your app's bundle ID
    handleCodeInApp: true,
    androidInstallApp: true,
    androidMinimumVersion: '19',
  );

  Future<void> resetPasswordWithPhone(PhoneNumber phoneNumber) async {
    Get.back(closeOverlays: true);

    // the main phone number function
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.completeNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then(
          (value) {
            value.user != null ? Get.to(() => OTPScreen()) : null;
          },
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        showErrorMessage('PHONE VERIFICATION', e.toString(),
            Icons.no_encryption_gmailerrorred);
      },
      codeSent: (String verificationID, int? resendToken) {
        _verificationCode.value = verificationID;
      },
      codeAutoRetrievalTimeout: ((verificationId) =>
          _verificationCode.value = verificationId),
      timeout: const Duration(seconds: 120),
    );
  }

  Future<void> resetPasswordWithEmail(String email) async {
    // actionCodeSettings: actionCodeSettings, add that to use a custom deep link
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showInfoMessage(
        'Email Verification Sent',
        'We have sent: **$email** a verification email. Please confirm to proceed.',
        Icons.mail_outline_rounded,
      );

      AuthController.find.login.value = true;

      Get.offAll(() => SignUpScreen(),
          transition: Transition.rightToLeftWithFade);
      return;
    } on FirebaseAuthException catch (e) {
      showErrorMessage(
        'Email Verification',
        'There was an error verifying $email: ${e.message}',
        Icons.mail_outline_rounded,
      );
    }
  }

  Future<void> completeOTP(String otp, String uid, String phoneNumber) async {
    await _auth
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: _verificationCode.value, smsCode: otp))
        .then(
      (value) async {
        if (value.user != null) {
          // update the user phone number
          try {
            await _firestore
                .collection('users')
                .doc(uid)
                .set({'phoneNumber': phoneNumber});

            refresh();
            await DestinationController.instance.getCurrentLocation();
            Get.offAll(() => HomeScreen());
          } catch (e) {
            showErrorMessage('Phone Verification',
                "Failed to add your number: $e", Icons.lock_person);
            rethrow;
          }

          // show a notification that the user's phone number has been added
          showSuccessMessage(
            'Phone Verification',
            'You have successfully verified your phone number: **$phoneNumber**',
            Icons.phone_android_sharp,
          );
        } else {
          return Get.back();
        }
      },
    );
  }

  Future<void> completePasswordReset() async {}
}
