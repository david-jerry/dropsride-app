import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/provider_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/reset_password_repository.dart';
import 'package:dropsride/src/features/auth/view/email_verification_screen.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/settings_and_legals/view/legal_page.dart';
import 'package:dropsride/src/features/transaction/controller/repository/card_repository.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get find => Get.find();
  static AuthController get instance => Get.put(
      AuthController()); // to be used like this AuthController.instance.functionOrVariable

  final userRepo = UserRepository.instance;

  final _auth = FirebaseAuth.instance;

  // form input fields
  // ? form input variables only
  RxBool check = false.obs;
  RxString confirmPasswordInput = ''.obs;
  RxString userFullName = ''.obs;
  RxString emailInput = ''.obs;
  RxBool forgotPasswordEmail = false.obs;
  RxString nameInput = ''.obs;
  RxString passwordInput = ''.obs;
  RxInt passwordScore = 0.obs;
  RxBool showPassword = false.obs;

  Timer? timer;

  // ! important variables to check the state of a user if they are driver or rider
  // user states
  RxBool isDriver = false.obs;
  RxBool isSubscribed = false.obs;
  RxDouble userBalance = 0.00.obs;
  RxBool isLoading = false.obs;
  RxBool login = false.obs;

  // ! import variable for the user to display their registered phone number
  // firebase user phone number detail
  Rx<PhoneNumberMap?> phoneNumber = PhoneNumberMap(
          countryISOCode: 'NG', countryCode: '+234', number: '555 123 4567')
      .obs;

  // ! useful variables for automatically verifying an email
  // email verification
  late Rx<Timer?> verificationTimer = Rx<Timer?>(null);
  RxBool isEmailVerified = false.obs;
  RxString otp = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ! this is to toggle the registration form from login to sign up and verse versa
  void toggleForm() {
    login.value = !login.value;
    showPassword.value = false;
  }

  // ! form necessary validation checks for password strength and field validations
  void passwordStrength(int score) => passwordScore.value = score;
  void validateFields(GlobalKey<FormState> formKey) {
    FocusScope.of(Get.context!).unfocus();
    if (formKey.currentState == null) {
      return;
    }
    formKey.currentState!.validate();
  }

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
  // ! form necessary validation checks end

  // ? This function helps go to the terms page
  void goToTerm() => Get.to(
        () => const LegalPage(),
        duration: const Duration(milliseconds: 800),
        transition: Transition.fadeIn,
      );

  Future<void> refreshUser() async {
    try {
      _auth.currentUser!.reload();
      showInfoMessage('Background Refresh',
          "Your information was updated successfully", Icons.task_alt);
    } catch (e) {
      showErrorMessage('Background Refresh Error', "Error refreshing user: $e",
          Icons.lock_person);
      rethrow;
    }
  }

  // ? User balance
  void getUserBalance() async {
    userBalance.value =
        await CardRepository.instance.getUserBalance(_auth.currentUser!);
    return;
  }

  // ? reset password functions either otp or email reset links
  Future<void> resetPasswordWithPhone() async {
    isLoading.value = true;
    Get.back(closeOverlays: true);

    PasswordResetRepository.instance.resetPasswordWithPhone(phoneNumber.value!);

    isLoading.value = false;
  }

  Future<void> resendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then(
          (value) => showSuccessMessage('Email Verification',
              'Email has been sent successfully!', Icons.mail_outline_rounded),
        )
        .catchError((error) {
      showErrorMessage(
          'Email Verification', error.toString(), Icons.mail_outline_rounded);
    });
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

  // ! driver specific function to switch modes
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

  // ! driver specific function to switch modes
  Future<void> updateSubscriptionStatus(User? user, bool value) async {
    isLoading.value = true;

    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'isSubscribed': value});
      isLoading.value = false;
    } catch (e) {
      isSubscribed.value = !value;
      showErrorMessage('Subscription Status Error',
          "Error updating your subscription status: $e", Icons.lock_person);
      isLoading.value = false;
      return;
    }
    update();
  }

  // ? Signup, SignIn and Sign out functions !!
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

    AuthenticationRepository.instance
        .loginUserWithEmailAndPassword(emailInput.value, passwordInput.value);
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

    final modelUser = UserModel(
      displayName: nameInput.value,
      email: emailInput.value,
      country: null,
      gender: null,
      isDriver: false,
      isVerified: false,
      joinedOn: DateTime.now(),
      dateOfBirth: null,
      password: passwordInput.value,
      phoneNumber: phoneNumber.value,
      acceptTermsAndCondition: check.value,
      photoUrl: null,
    );

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

    await AuthenticationRepository.instance.createUserWithEmailAndPassword(
      modelUser.email!,
      modelUser.password!,
      modelUser.displayName!,
      modelUser.acceptTermsAndCondition,
    );

    await userRepo.createFirestoreUser(modelUser);

    isLoading.value = false;

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
        FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.isActive ? timer.cancel() : null;
          await AuthenticationRepository.instance.checkDriverStatus();
          AuthenticationRepository.instance.firebaseUser.value =
              FirebaseAuth.instance.currentUser;
          await DestinationController.instance.getCurrentLocation();
          Get.offAll(() => const HomeScreen());
        }
      });

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Get.to(() => const EmailVerificationScreen());
      }
    }
  }

  // ? Social authentications
  // Google sign in button function
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithGoogle(login.value);

    isLoading.value = false;

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.isActive ? timer.cancel() : null;
          AuthenticationRepository.instance.checkDriverStatus();
          AuthenticationRepository.instance.firebaseUser.value =
              FirebaseAuth.instance.currentUser;
          Get.offAll(() => const HomeScreen());
        }
      });

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Get.to(() => const EmailVerificationScreen());
      }
    }
  }

  // Facebook sign in button function
  Future<void> signInWithFacebook() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithFacebook(login.value);

    isLoading.value = false;

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.isActive ? timer.cancel() : null;
          AuthenticationRepository.instance.checkDriverStatus();
          AuthenticationRepository.instance.firebaseUser.value =
              FirebaseAuth.instance.currentUser;
          Get.offAll(() => const HomeScreen());
        }
      });

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Get.to(() => const EmailVerificationScreen());
      }
    }
  }

  // Apple sign in button function
  Future<void> signInWithApple() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithApple(login.value);

    isLoading.value = false;

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.isActive ? timer.cancel() : null;
          AuthenticationRepository.instance.checkDriverStatus();
          AuthenticationRepository.instance.firebaseUser.value =
              FirebaseAuth.instance.currentUser;
          Get.offAll(() => const HomeScreen());
        }
      });

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Get.to(() => const EmailVerificationScreen());
      }
    }
  }
}
