import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/login_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/signup_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/provider_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/reset_password_repository.dart';
import 'package:dropsride/src/features/auth/view/email_verification_screen.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/splash/view/screen.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  // email verification variables
  RxBool isEmailVerified = false.obs;
  RxInt count = 1.obs;
  Timer? timer;

  // Called immediately the controller is called
  @override
  void onReady() async {
    // signOutUser();

    Future.delayed(const Duration(seconds: 3));
    Get.put(SocialProviderRepository());
    Get.put(EmailVerificationRepository());
    Get.put(PasswordResetRepository());
    Get.put(AuthController());

    firebaseUser = Rx<User?>(_auth.currentUser);

    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);

    if (firebaseUser.value != null) {
      if (firebaseUser.value!.displayName == null) {
        signOutUser();
        update();
        return;
      }

      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .get();

      // firestore information
      if (userSnapshot.exists) {
        AuthController.instance.isDriver.value =
            userSnapshot.get('isDriver') ?? false;
        AuthController.instance.nameInput.value =
            userSnapshot.get('name') ?? '';
        AuthController.instance.phoneNumber.value =
            userSnapshot.get('phoneNumber').toString().isNotEmpty
                ? userSnapshot.get('phoneNumber')
                : '+234 701 234 5678';
      }
    }

    super.onReady();
  }

  // initial state of the controller
  _setInitialScreen(User? user) {
    // if the user is not null go straight to the dashboard
    if (user == null) {
      Get.offAll(() => SplashScreen());
    } else {
      if (user.emailVerified) {
        Get.offAll(() => const HomeScreen());
        timer?.cancel();
      } else {
        if (count > 0) {
          EmailVerificationRepository.instance.sendVerification(user);
          count.value--;
          timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
            update();
            firebaseUser.value!.reload();
          });
        } else {
          Get.to(() => const EmailVerificationScreen());
        }
      }
    }
  }

  // set the user roles
  Future<void> setRoleMode(
      String uid, bool isStaff, bool check, String displayName) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': displayName,
        'phoneNumber': '',
        'isDriver': false,
        'isStaff': isStaff,
        'acceptTermsAndPrivacy': check,
        'acceptedDate': DateTime.now(),
        'joined': DateTime.now(),
      });
    } catch (e) {
      showErrorMessage('User Role', "Error setting your role as a user: $e",
          Icons.lock_person);
      rethrow;
    }
    update();
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String displayName, bool check) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (firebaseUser.value != null) {
        // set the user and driver roles
        await setRoleMode(firebaseUser.value!.uid, false, check, displayName);

        // Send a success alert
        showSuccessMessage(
            'Registration',
            "You have successfully created an account with this email address: ${firebaseUser.value!.email}",
            Icons.lock_person);

        // send verification email to the user if they are not null
        await EmailVerificationRepository.instance
            .sendVerification(firebaseUser.value!);

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

      if (firebaseUser.value != null) {
        // Send a success alert
        showSuccessMessage(
            'Authentication Successful',
            "You have successfully logged into your account with this email address: ${firebaseUser.value!.email}",
            Icons.lock_person);

        // send verification email to the user if they have not verified their email
        await EmailVerificationRepository.instance
            .sendVerification(firebaseUser.value!);
      }
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
    }
  }

  Future<void> signOutUser() async {
    FirebaseAuth.instance.signOut();
  }
}
