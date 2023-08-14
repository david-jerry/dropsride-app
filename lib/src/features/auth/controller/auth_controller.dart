import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/provider_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/reset_password_repository.dart';
import 'package:dropsride/src/features/auth/view/email_verification_screen.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/model/direction_details_info_model.dart';
import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:dropsride/src/features/home/model/driver_data.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/bank_model.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/settings_and_legals/view/legal_page.dart';
import 'package:dropsride/src/features/trips/model/location_model.dart';
import 'package:dropsride/src/features/trips/model/trip_model.dart';
import 'package:dropsride/src/features/vehicle/model/vehicle_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.put(
      AuthController()); // to be used like this AuthController.find.functionOrVariable
  static AuthController get find => Get.find<AuthController>();

  final _auth = FirebaseAuth.instance;

  // form input fields
  // ? form input variables only
  RxBool check = false.obs;
  RxBool getNewMarkers = true.obs;
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
  RxBool isLoading = false.obs;
  RxBool login = false.obs;
  Rx<User?> user = Rx<User?>(null);
  Rx<UserModel?> userModel = UserModel().obs;
  Rx<DriverData?> driverData = DriverData().obs;
  RxList<UserModel> driversList = <UserModel>[].obs;
  Rx<VehicleModel?> driverVehicleModel = VehicleModel().obs;
  RxList<dynamic> bankList = [].obs;
  Rx<Bank?> userBank = Bank().obs;
  RxList<TripsHistoryModel> userTrips = <TripsHistoryModel>[].obs;
  RxInt userRating = 0.obs;
  RxDouble driverAcceptanceRate = 0.0.obs;
  RxDouble driverCancellationRate = 0.0.obs;

  // ! Users current state
  Rx<Location?> userCurrentState = Location().obs;

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

  // ? reset password functions either otp or email reset links
  Future<void> resetPasswordWithPhone() async {
    isLoading.value = true;
    Get.back(closeOverlays: true);

    PasswordResetRepository.instance.resetPasswordWithPhone(phoneNumber.value!);

    isLoading.value = false;
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser!
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
  // ? end password reset functions

  // ! driver specific function to switch modes
  Future<void> updateDriverMode(User? user) async {
    userModel.value!.isDriver = !userModel.value!.isDriver;
    if (!userModel.value!.isDriver) {
      MapController.find.locateUserPosition();
      driverData.value = DriverData();
    } else {
      driverData.value = DriverData(
        carColor: driverVehicleModel.value!.carColor,
        carModel: driverVehicleModel.value!.carModel,
        carNumber: driverVehicleModel.value!.carPlateNumber,
        carType: userModel.value!.carType!.name,
        email: userModel.value!.email,
        id: userModel.value!.uid,
        name: userModel.value!.displayName,
        phone: userModel.value!.phoneNumber!.number,
        totalEarnings: userModel.value!.totalEarnings,
      );
    }
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'isDriver': userModel.value!.isDriver});
      AssistantMethods.refreshUserInfo();
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
    update();
    return;
  }

  // ! driver specific function to come online
  Future<void> comeOnline(User? user) async {
    MapController.find.markers.clear();
    userModel.value!.isOnline = true;
    MapController.find.locateUserPosition();
    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'isOnline': true,
        'latitude': MapController.find.pickLocation.value.latitude,
        'longitude': MapController.find.pickLocation.value.longitude,
      });
      AssistantMethods.refreshUserInfo();

      // DatabaseReference ref = FirebaseDatabase.instance
      //     .ref()
      //     .child('drivers')
      //     .child(userModel.value!.uid!)
      //     .child('newRideStatus');
      // ref.set('idle');
      // ref.onValue.listen((event) {});

      // initialize active drivers this creates a new collection in the firestore database
      await Geofire.initialize('activeDrivers');
      await Geofire.setLocation(
        userModel.value!.uid!,
        MapController.find.pickLocation.value.latitude,
        MapController.find.pickLocation.value.longitude,
      );

      await UserRepository.instance.getUserRideStatus(RideStatus.idle);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {});
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
    // update();
  }

  Future<void> driverGoOffline(User? user) async {
    userModel.value!.isOnline = false;
    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'isOnline': false,
        'latitude': null,
        'longitude': null,
      });
      AssistantMethods.refreshUserInfo();
      await Geofire.removeLocation(userModel.value!.uid!);
      MapController.find.locateUserPosition();

      await UserRepository.instance.getUserRideStatus(RideStatus.idle);
      update();
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
  }

  // ! subscribe to take rides
  Future<void> updateSubscriptionStatus(User? user, bool value) async {
    userModel.value!.isSubscribed = value;
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'isSubscribed': value});
      AssistantMethods.refreshUserInfo();
    } catch (e) {
      userModel.value!.isSubscribed = !value;
      showErrorMessage('Subscription Status Error',
          "Error updating your subscription status: $e", Icons.lock_person);
      return;
    }
    update();
    return;
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

    await AuthenticationRepository.instance
        .loginUserWithEmailAndPassword(emailInput.value, passwordInput.value);
  }

  Future<void> signOutUser() async {
    _auth.signOut();
    main();
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

    if (modelUser.displayName != null) {
      await UserRepository.instance.createFirestoreUser(modelUser);
    } else {
      _auth.currentUser!.delete();
      _auth.currentUser!.reload();
    }

    isLoading.value = false;

    if (_auth.currentUser != null) {
      _auth.currentUser!.reload();

      // send verification email to the user if they are not null
      if (!_auth.currentUser!.emailVerified) {
        await EmailVerificationRepository.instance
            .sendVerification(_auth.currentUser!);
        Get.offAll(() => const EmailVerificationScreen());
      }

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
        _auth.currentUser!.reload();
        if (_auth.currentUser!.emailVerified) {
          timer.isActive ? timer.cancel() : null;
          await DestinationController.instance.getCurrentLocation();
          Get.offAll(() => const HomeScreen());
        }
      });
    }
  }

  // ? Social authentications
  // Google sign in button function
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithGoogle(login.value);

    isLoading.value = false;

    // if (_auth.currentUser != null) {
    //   _auth.currentUser!.reload();

    //   Timer.periodic(
    //     const Duration(seconds: 5),
    //     (Timer timer) {
    //       _auth.currentUser!.reload();
    //       if (_auth.currentUser!.emailVerified) {
    //         timer.isActive ? timer.cancel() : null;
    //         Get.offAll(() => const HomeScreen());
    //       }
    //     },
    //   );

    //   if (!_auth.currentUser!.emailVerified) {
    //     Get.to(() => const EmailVerificationScreen());
    //   }
    // }
  }

  // Facebook sign in button function
  Future<void> signInWithFacebook() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithFacebook(login.value);

    isLoading.value = false;

    // if (_auth.currentUser != null) {
    //   _auth.currentUser!.reload();

    //   timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
    //     _auth.currentUser!.reload();
    //     if (_auth.currentUser!.emailVerified) {
    //       timer.isActive ? timer.cancel() : null;
    //       Get.offAll(() => const HomeScreen());
    //     }
    //   });

    //   if (!_auth.currentUser!.emailVerified) {
    //     Get.to(() => const EmailVerificationScreen());
    //   }
    // }
  }

  // Apple sign in button function
  Future<void> signInWithApple() async {
    isLoading.value = true;

    await SocialProviderRepository.instance.signInWithApple(login.value);

    isLoading.value = false;

    // if (_auth.currentUser != null) {
    //   _auth.currentUser!.reload();

    //   timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
    //     _auth.currentUser!.reload();
    //     if (_auth.currentUser!.emailVerified) {
    //       timer.isActive ? timer.cancel() : null;
    //       Get.offAll(() => const HomeScreen());
    //     }
    //   });

    //   if (!_auth.currentUser!.emailVerified) {
    //     Get.to(() => const EmailVerificationScreen());
    //   }
    // }
  }

  void main() async {
    MapController.find.active.value = false;
    MapController.find.rideAccepted.value = false;
    MapController.find.searchingDropoff.value = true;
    MapController.find.locationChanged.value = false;
    MapController.find.isDriverActive.value = false;
    MapController.find.locationInitialized.value = false;
    MapController.find.openedAddressSearch.value = false;
    MapController.find.openedSelectCar.value = false;
    MapController.find.confirmTrip.value = false;
    MapController.find.hasLoadedMarker.value = false;
    MapController.find.dropOffSelected.value = false;
    MapController.find.pickupSelected.value = false;
    MapController.find.userDropOffLocation.value = Directions();
    MapController.find.userPickupLocation.value = Directions();
    MapController.find.tripInfo.value = DirectionDetailsInfo();
    MapController.find.pLineCoordinatedList.value = <LatLng>[];
    MapController.find.listCordinates.value = <LatLng>[];
    MapController.find.markers.clear();
    MapController.find.circles.clear();
    check.value = false;
    getNewMarkers.value = true;
    confirmPasswordInput.value = '';
    userFullName.value = '';
    emailInput.value = '';
    forgotPasswordEmail.value = false;
    nameInput.value = '';
    passwordInput.value = '';
    passwordScore.value = 0;
    showPassword.value = false;
    isLoading.value = false;
    login.value = false;
    user.value = null;
    userModel.value = UserModel();
    bankList.value = [];
    userBank.value = Bank();
    driversList.value = [];
    userRating.value = 0;
    userCurrentState.value = Location();
    phoneNumber.value = PhoneNumberMap(
        countryISOCode: 'NG', countryCode: '+234', number: '555 123 4567');
    verificationTimer.value = null;
    isEmailVerified.value = false;
    otp.value = '';

    AuthController.find.login.value = true;

    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        Get.offAll(() => SignUpScreen());
      },
    );
    // run the main app here
  }
}
