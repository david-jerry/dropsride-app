import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/login_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/signup_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

import 'package:get_storage/get_storage.dart';

import '../../../transaction/controller/subscription_controller.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  late Rx<UserModel?> userData;
  final String _timerKey = 'countdown_timer';

  // email verification variables
  RxBool isEmailVerified = false.obs;
  RxInt count = 1.obs;
  late final Timer? timer;

  // Called immediately the controller is called
  @override
  void onReady() async {
    firebaseUser.value = _auth.currentUser;
    super.onReady();
  }

  checkDriverStatus() async {
    if (_auth.currentUser!.email.toString().isNotEmpty) {
      userData = Rx<UserModel?>(await UserRepository.instance
          .getUserDetails(_auth.currentUser!.email!));

      // firestore information
      if (userData.value!.email!.isNotEmpty) {
        AuthController.instance.isDriver.value = userData.value!.isDriver;
      }
    } else {
      return;
    }
  }

  checkDriverSubscription() async {
    if (_auth.currentUser!.email.toString().isNotEmpty) {
      userData = Rx<UserModel?>(await UserRepository.instance
          .getUserDetails(_auth.currentUser!.email!));

      // firestore information
      if (AuthController.instance.isDriver.value) {
        final int storedTime = GetStorage().read(_timerKey) ?? 0;
        final int currentTime = DateTime.now().millisecondsSinceEpoch;

        if (currentTime > storedTime || userData.value!.isSubscribed == false) {
          SubscriptionController.instance.clearTimer();
          SubscriptionController.instance.resetTimerFields();
          return;
        }
        AuthController.instance.isSubscribed.value =
            userData.value!.isSubscribed;

        print("User is subscribed?: ${userData.value!.isSubscribed}");
      }
    } else {
      return;
    }
  }

  // set the user roles
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String displayName, bool check) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      firebaseUser.value = _auth.currentUser;

      if (firebaseUser.value != null) {
        // Send a success alert
        showSuccessMessage(
            'Registration',
            "You have successfully created an account with this email address: ${firebaseUser.value!.email}",
            Icons.lock_person);

        // send verification email to the user if they are not null
        if (!firebaseUser.value!.emailVerified) {
          await EmailVerificationRepository.instance
              .sendVerification(firebaseUser.value!);
        }

        // update the user's display name
        await firebaseUser.value!.updateDisplayName(displayName);
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

      firebaseUser.value = _auth.currentUser;

      if (firebaseUser.value != null) {
        // Send a success alert
        showSuccessMessage(
            'Authentication Successful',
            "You have successfully logged into your account with this email address: ${firebaseUser.value!.email}",
            Icons.lock_person);

        if (!firebaseUser.value!.emailVerified) {
          // send verification email to the user if they have not verified their email
          await EmailVerificationRepository.instance
              .sendVerification(firebaseUser.value!);
        }

        AuthController.instance.isLoading.value = false;

        if (FirebaseAuth.instance.currentUser != null) {
          AuthenticationRepository.instance.firebaseUser.value =
              FirebaseAuth.instance.currentUser;
        }

        await DestinationController.instance.getCurrentLocation();

        Get.offAll(() => const HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
      AuthController.instance.isLoading.value = false;
    }
  }

  Future<void> signOutUser() async {
    _auth.signOut();
  }
}
