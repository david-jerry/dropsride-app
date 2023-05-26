import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/provider_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/reset_password_repository.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/settings_and_legals/view/legal_page.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl_phone_field/phone_number.dart';

class AuthController extends GetxController {
  static AuthController get find => Get.find();

  static AuthController get instance => Get.put(
      AuthController()); // to be used like this AuthController.instance.functionOrVariable

  final _auth = FirebaseAuth.instance;

  // form input fields
  RxBool check = false.obs;
  RxString confirmPasswordInput = ''.obs;
  RxString emailInput = ''.obs;
  RxBool forgotPasswordEmail = false.obs;
  RxString nameInput = ''.obs;
  RxString passwordInput = ''.obs;
  RxInt passwordScore = 0.obs;
  Rx<PhoneNumber?> phoneInput = PhoneNumber(
          countryISOCode: 'NG', countryCode: '+234', number: '555 123 4567')
      .obs;

  // user states
  RxBool isDriver = false.obs;
  RxBool isLoading = false.obs;
  RxBool login = true.obs;

  // firebase user detail
  RxString phoneNumber = '+234 701 234 5678'.obs;
  late Rx<User?> user = Rx<User?>(null);

  // email verification
  late Rx<Timer?> verificationTimer = Rx<Timer?>(null);
  RxBool isEmailVerified = false.obs;
  RxString otp = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // set the driver mode on initialization of the auth controller
  @override
  void onReady() async {
    isLoading.value = false;
    Future.delayed(const Duration(seconds: 3));
  }

  void toggleForm() => login.value = !login.value;

  void passwordStrength(int score) => passwordScore.value = score;

  void validateFields(GlobalKey<FormState> formKey) {
    FocusScope.of(Get.context!).unfocus();
    if (formKey.currentState == null) {
      return;
    }
    formKey.currentState!.validate();
  }

  void goToTerm() => Get.to(
        () => const LegalPage(),
        duration: const Duration(milliseconds: 800),
        transition: Transition.fadeIn,
      );

  void checkPasswordStrength(value) {
    if (!validateRequired(value)) {
      passwordStrength(0);
    } else if (validateRequired(value) &&
        validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8) &&
        passwordHasSpecialCharacter(value) &&
        passwordHasNumber(value) &&
        passwordHasUppercaseLetter(value)) {
      passwordStrength(4);
    } else if (validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8) &&
        passwordHasSpecialCharacter(value) &&
        passwordHasNumber(value)) {
      passwordStrength(3);
    } else if (validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8)) {
      passwordStrength(2);
    } else if (validateMinimumLength(value, 6)) {
      passwordStrength(1);
    }
  }

  Future<void> refreshUser() async {
    try {
      user = Rx<User?>(_auth.currentUser);
      await user.value!.reload();
      user = Rx<User?>(_auth.currentUser);
      showInfoMessage('Background Refresh',
          "Your information was updated successfully", Icons.task_alt);
    } catch (e) {
      showErrorMessage('Background Refresh Error', "Error refreshing user: $e",
          Icons.lock_person);
      rethrow;
    }
  }

  Future<void> resetPasswordWithPhone() async {
    isLoading.value = true;
    Get.back(closeOverlays: true);

    PasswordResetRepository.instance.resetPasswordWithPhone(phoneNumber.value);

    isLoading.value = false;
  }

  Future<void> resetPasswordWithEmail() async {
    isLoading.value = true;

    PasswordResetRepository.instance.resetPasswordWithEmail(emailInput.value);

    isLoading.value = false;
  }

  Future<void> completeOTP(String otp) async {
    isLoading.value = true;

    PasswordResetRepository.instance
        .completeOTP(emailInput.value, passwordInput.value, nameInput.value);

    isLoading.value = false;
  }

  Future<void> completePasswordReset() async {}

  Future<void> updateDriverMode(User? user) async {
    isLoading.value = true;
    isDriver.value = !isDriver.value;

    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'isDriver': isDriver.value});
      isLoading.value = false;
      await refreshUser();
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
    isLoading.value = false;
    update();
  }

// Signup and Login Controllers
  Future<void> loginUser(GlobalKey<FormState> formKey) async {
    isLoading.value = true;

    // check form validity first
    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Authentication Warning',
          "You must validate all necessary fields before submitting!",
          Icons.key_sharp);

      isLoading.value = false;
      return;
    }

    formKey.currentState!.save();
    formKey.currentState?.reset();
    passwordScore.value = 0;

    SocialProviderRepository.instance
        .loginUserWithEmailAndPassword(emailInput.value, passwordInput.value);

    isLoading.value = false;
    return;
  }

  Future<void> signOutUser() async {
    _auth.signOut();
    Get.offAll(() => SignUpScreen());
  }

  Future<void> createNewUser(GlobalKey<FormState> formKey) async {
    isLoading.value = true;

    // check if user accepted terms and condition before signing up
    if (!check.value && !login.value) {
      showWarningMessage(
          'Authentication Warning',
          "You must accept our terms and privacy after reading them to be able to sign up!",
          Icons.lock_person);

      isLoading.value = false;
      return;
    }

    // SignOut any authenticated user to sign up a new user
    _auth.signOut();

    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Authentication Warning',
          "You must validate all necessary fields before submitting!",
          Icons.text_fields_sharp);

      isLoading.value = false;
      return;
    }

    formKey.currentState!.save();
    formKey.currentState?.reset();
    passwordScore.value = 0;

    AuthenticationRepository.instance.createUserWithEmailAndPassword(
        emailInput.value, passwordInput.value, nameInput.value, check.value);

    isLoading.value = false;
    return;
  }

  // Google sign in button function
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithGoogle(login.value);

    isLoading.value = false;
  }

  // Facebook sign in button function
  Future<void> signInWithFacebook() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithFacebook(login.value);

    isLoading.value = false;
  }

  // Apple sign in button function
  Future<void> signInWithApple() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithApple(login.value);

    isLoading.value = false;
  }
}
