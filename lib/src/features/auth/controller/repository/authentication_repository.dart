import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/login_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/signup_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;

  // set the user roles
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String displayName, bool check) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (_auth.currentUser != null) {
        // update the user's display name
        await _auth.currentUser!.updateDisplayName(displayName);

        // Send a success alert
        showSuccessMessage(
            'Registration',
            "You have successfully created an account with this email address: ${_auth.currentUser!.email}",
            Icons.lock_person);
        AuthController.find.getNewMarkers.value = true;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
    }
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_auth.currentUser != null) {
        // Send a success alert
        showSuccessMessage(
            'Authentication Successful',
            "You have successfully logged into your account with this email address: ${_auth.currentUser!.email}",
            Icons.lock_person);

        if (!_auth.currentUser!.emailVerified) {
          // send verification email to the user if they have not verified their email
          await EmailVerificationRepository.instance
              .sendVerification(_auth.currentUser!);
        }

        AuthController.find.isLoading.value = false;

        AssistantMethods.readOnlineUserCurrentInfo();
        AuthController.find.getNewMarkers.value = true;
        MapController.find.onBuildCompleted();
        await DestinationController.instance.getCurrentLocation();

        Future.delayed(const Duration(milliseconds: 5500), () {
          Get.offAll(() => const HomeScreen());
        });
      }
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
      AuthController.find.isLoading.value = false;
    }
  }

  Future<void> signOutUser() async {
    _auth.signOut();
  }
}
