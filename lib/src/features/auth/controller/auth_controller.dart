import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/view/otp.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/features/legals/view/legal_page.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  RxBool check = false.obs;
  RxString confirmPasswordInput = ''.obs;
  RxString emailInput = ''.obs;
  RxBool forgotPasswordEmail = false.obs;
  late final formKey = GlobalKey<FormState>();
  RxBool isDriver = false.obs;
  RxBool isEmailVerified = false.obs;
  RxBool isLoading = false.obs;
  RxBool login = true.obs;
  RxString nameInput = ''.obs;
  RxString otp = ''.obs;
  RxString passwordInput = ''.obs;
  RxInt passwordScore = 0.obs;
  Rx<PhoneNumber?> phoneInput = PhoneNumber(
          countryISOCode: 'NG', countryCode: '+234', number: '555 123 4567')
      .obs;

  late Rx<User?> user = Rx<User?>(null);
  late Rx<Timer?> verificationTimer = Rx<Timer?>(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxString _verificationCode = ''.obs;

  // set the driver mode on initialization of the auth controller
  @override
  void onReady() async {
    isLoading.value = false;
    user = Rx<User?>(FirebaseAuth.instance.currentUser);
    if (user.value != null) {
      // FirebaseAuth.instance.signOut();
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.value!.uid).get();
      if (userSnapshot.exists) {
        isDriver.value = userSnapshot.get('isDriver') ?? false;
        nameInput.value = userSnapshot.get('name') ?? '';
      }
    }
  }

  static AuthController get find => Get.find();

  static AuthController get instance => Get.put(
      AuthController()); // to be used like this AuthController.instance.functionOrVariable

  void toggleForm() => login.value = !login.value;

  void passwordStrength(int score) => passwordScore.value = score;

  void validateFields() {
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
      user = Rx<User?>(FirebaseAuth.instance.currentUser);
      await user.value!.reload();
      user = Rx<User?>(FirebaseAuth.instance.currentUser);
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
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber:
          '${phoneInput.value!.countryCode}${phoneInput.value!.number.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then(
              (value) => value.user != null ? Get.to(() => OTPScreen()) : null,
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
    isLoading.value = false;
  }

  Future<void> resetPasswordWithEmail() async {
    // final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    //   url:
    //       'https://dropsride.page.link/reset-password/', // Update with your app's dynamic link domain
    //   androidPackageName:
    //       'com.dropsride.android', // Update with your app's package name
    //   iOSBundleId: 'com.dropsride.apple', // Update with your app's bundle ID
    //   handleCodeInApp: true,
    //   androidInstallApp: true,
    //   androidMinimumVersion: '19',
    // );

    await FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: emailInput.value,
      // actionCodeSettings: actionCodeSettings,
    )
        .then(
      (value) {
        showInfoMessage(
          'Email Verification Sent',
          'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
          Icons.email_rounded,
        );

        login.value = true;
        Get.off(() => SignUpScreen());
      },
    ).catchError(
      (e) {
        showErrorMessage(
          'Email Verification',
          'There was an error verifying **$emailInput**: $e ',
          Icons.mail_outline_rounded,
        );
      },
    );
  }

  Future<void> completeOTP(String otp) async {
    isLoading.value = true;
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: _verificationCode.value, smsCode: otp))
        .then(
      (value) async {
        if (value.user != null) {
          user = Rx<User>(value.user!);

          // update the user phone number
          try {
            await _firestore.collection('users').doc(user.value!.uid).set({
              'phoneNumber':
                  '${phoneInput.value!.countryCode}${phoneInput.value!.number.trim()}'
            });

            refresh();

            // TODO: Chnage this to the main map screen
            Get.off(() => const LegalPage());
          } catch (e) {
            showErrorMessage('Phone Verification',
                "Failed to add your number: $e", Icons.lock_person);
            rethrow;
          }

          // show a notification that the user's phone number has been added
          showSuccessMessage(
            'Phone Verification',
            'You have successfully verified your phone number: **${phoneInput.value!.countryCode}${phoneInput.value!.number.trim()}**',
            Icons.phone_android_sharp,
          );

          // then redirect to the login page
          isLoading.value = false;
          return Get.off(() => const LegalPage());
        } else {
          isLoading.value = false;
          return Get.back();
        }
      },
    );
  }

  Future<void> completePasswordReset() async {}

  // Future<void> setIsDriverMode(String uid, bool isDriver) async {
  //   try {
  //     await _firestore.collection('users').doc(uid).set({'isDriver': isDriver});
  //     showInfoMessage('Background Info',
  //         "You are now a registered rider on dropsride", Icons.task_alt);
  //   } catch (e) {
  //     showErrorMessage('Driver Role Error',
  //         "Error setting your mode as a rider: $e", Icons.lock_person);
  //     rethrow;
  //   }
  // }

  Future<void> updateDriverMode() async {
    isLoading.value = true;
    isDriver.value = !isDriver.value;

    try {
      await _firestore
          .collection('users')
          .doc(user.value!.uid)
          .update({'isDriver': isDriver.value});
      isLoading.value = false;
      await refreshUser();
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
    isLoading.value = false;
  }

  Future<void> setRoleMode(String uid, bool isStaff) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameInput.value,
        'phoneNumber': '',
        'isDriver': false,
        'isStaff': isStaff,
        'acceptTermsAndPrivacy': check.value,
        'acceptedDate': DateTime.now(),
        'joined': DateTime.now(),
      });
    } catch (e) {
      showErrorMessage('User Role', "Error setting your role as a user: $e",
          Icons.lock_person);
      rethrow;
    }
  }

  Future<void> checkEmailVerificationStatus(Rx<User?> user) async {
    if (user.value!.emailVerified) {
      isEmailVerified.value = true;
      user.value!.reload();
      // Email is verified, navigate to the new page
      verificationTimer.value!.cancel(); // Stop the timer
      Get.off(() => const LegalPage());
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
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

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailInput.value, password: passwordInput.value);

      if (credential.user != null) {
        user = Rx<User?>(credential.user);
        if (!user.value!.emailVerified) {
          await user.value!.sendEmailVerification(
              // ActionCodeSettings(
              //   url:
              //       'https://dropsride.page.link/verify-email/', // Update with your app's dynamic link domain
              //   androidPackageName:
              //       'com.dropsride.android', // Update with your app's package name
              //   iOSBundleId:
              //       'com.dropsride.apple', // Update with your app's bundle ID
              //   handleCodeInApp: true,
              //   androidInstallApp: true,
              //   androidMinimumVersion: '19',
              // ),
              );

          // Start the timer to periodically check email verification status
          // verificationTimer.value =
          //     Timer.periodic(const Duration(seconds: 1), (timer) {
          //   checkEmailVerificationStatus(user);
          // });

          // if (!isEmailVerified.value) {
          //   Get.bottomSheet(
          //     backgroundColor:
          //         Theme.of(Get.context!).colorScheme.secondaryContainer,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(AppSizes.padding),
          //     ),
          //     Container(
          //         padding: const EdgeInsets.symmetric(
          //             horizontal: AppSizes.padding * 2,
          //             vertical: AppSizes.padding),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             hSizedBox4,
          //             Text(
          //               'Verification Processing?',
          //               style: Theme.of(Get.context!)
          //                   .textTheme
          //                   .headlineMedium!
          //                   .copyWith(
          //                     fontWeight: FontWeight.w900,
          //                     color: Theme.of(Get.context!)
          //                         .colorScheme
          //                         .onBackground,
          //                   ),
          //             ),
          //             hSizedBox2,
          //             Text(
          //               'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
          //               style: Theme.of(Get.context!)
          //                   .textTheme
          //                   .labelLarge!
          //                   .copyWith(
          //                     letterSpacing: 1,
          //                   ),
          //             ),
          //             const SizedBox(height: 16.0),
          //             Visibility(
          //               visible: !user.value!.emailVerified ? true : false,
          //               child: const CircularProgressIndicator(),
          //             ),
          //             const SizedBox(height: 16.0),
          //             // Divider(
          //             //   height: AppSizes.p18 * 2.8,
          //             //   color: Theme.of(Get.context!).colorScheme.onBackground,
          //             // ),
          //             // CustomButtons(
          //             //     ontap: () {
          //             //       Get.back();
          //             //     },
          //             //     icon: Icons.email_rounded,
          //             //     title: "Cancel",
          //             //     description: "Reset via email verification"),
          //           ],
          //         )),
          //   );
          // }

          showInfoMessage(
            'Email Verification Sent',
            'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
            Icons.email_rounded,
          );
        }

        showSuccessMessage(
            'Authenticated',
            'You successfully logged into your account: **$emailInput**',
            Icons.face_unlock_sharp);

        isLoading.value = false;
        Get.off(() => const LegalPage());
      }
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showWarningMessage("Authentication Warning",
            "No user found for that email.", Icons.lock_person);
      } else if (e.code == 'wrong-password') {
        showWarningMessage("Authentication Error",
            'Wrong password provided for that user.', Icons.password_sharp);
      }
    }

    isLoading.value = false;
    return;
  }

  Future<void> signOutUser() async {
    Get.delete<AuthController>();
    Get.put(AuthController());
    AuthController.instance.user.value = null;
    AuthController.instance.login.value = true;
    FirebaseAuth.instance.signOut();
    Get.off(() => SignUpScreen());
  }

  Future<void> createNewUser() async {
    isLoading.value = true;
    if (!check.value && !login.value) {
      showWarningMessage(
          'Authentication Warning',
          "You must accept our terms and privacy after reading them to be able to sign up!",
          Icons.lock_person);

      isLoading.value = false;
      return;
    }

    FirebaseAuth.instance.signOut();

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

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailInput.value,
        password: passwordInput.value,
      );

      if (credential.user != null) {
        user = Rx<User?>(credential.user);
        await user.value!.updateDisplayName(nameInput.value);
        login.value = true;

        // if the user is not null create a default user and driver roles for the user
        await setRoleMode(user.value!.uid, false);

        await user.value!.sendEmailVerification(
            // ActionCodeSettings(
            //   url:
            //       'https://dropsride.page.link/verify-email/', // Update with your app's dynamic link domain
            //   androidPackageName:
            //       'com.dropsride.android', // Update with your app's package name
            //   iOSBundleId:
            //       'com.dropsride.apple', // Update with your app's bundle ID
            //   handleCodeInApp: true,
            //   androidInstallApp: true,
            //   androidMinimumVersion: '19',
            // ),
            );

        // Start the timer to periodically check email verification status
        // verificationTimer.value =
        //     Timer.periodic(const Duration(seconds: 1), (timer) {
        //   checkEmailVerificationStatus(user);
        // });

        showInfoMessage(
          'Email Verification Sent',
          'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
          Icons.email_rounded,
        );

        // if (!isEmailVerified.value) {
        //   Get.bottomSheet(
        //     backgroundColor:
        //         Theme.of(Get.context!).colorScheme.secondaryContainer,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(AppSizes.padding),
        //     ),
        //     Container(
        //       padding: const EdgeInsets.symmetric(
        //           horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           hSizedBox4,
        //           Text(
        //             'Verification Processing?',
        //             style: Theme.of(Get.context!)
        //                 .textTheme
        //                 .headlineMedium!
        //                 .copyWith(
        //                   fontWeight: FontWeight.w900,
        //                   color:
        //                       Theme.of(Get.context!).colorScheme.onBackground,
        //                 ),
        //           ),
        //           hSizedBox2,
        //           Text(
        //             'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
        //             style:
        //                 Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
        //                       letterSpacing: 1,
        //                     ),
        //           ),
        //           const SizedBox(height: 16.0),
        //           Visibility(
        //             visible: !user.value!.emailVerified ? true : false,
        //             child: const CircularProgressIndicator(),
        //           ),
        //           const SizedBox(height: 16.0),
        //           Divider(
        //             height: AppSizes.p18 * 2.8,
        //             color: Theme.of(Get.context!).colorScheme.onBackground,
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }

        Get.off(() => const LegalPage());

        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showInfoMessage("Authentication Error",
            'The password provided is too weak.', Icons.password_sharp);
      } else if (e.code == 'email-already-in-use') {
        showInfoMessage("Authentication Error",
            'The account already exists for that email.', Icons.lock_person);
      }
    } catch (e) {
      showErrorMessage("Authentication Error", e.toString(), Icons.lock_person);
    }

    isLoading.value = false;
    return;
  }

  // Google sign in button function
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final credential =
        await FirebaseAuth.instance.signInWithCredential(googleCredential);

    if (credential.user != null) {
      user = Rx<User?>(credential.user);

      if (!login.value) {
        // link the credentials with the user
        try {
          await FirebaseAuth.instance.currentUser
              ?.reauthenticateWithCredential(googleCredential);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "provider-already-linked":
              var message = "The provider has already been linked to the user.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "invalid-credential":
              var message = "The provider's credential is not valid.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "credential-already-in-use":
              var message =
                  "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            // See the API reference for the full list of error codes.
            default:
              var message = "Unknown error.";
              showErrorMessage("Account Linking", message, Icons.account_box);
          }
        }

        // if the user is not null create a default user and driver roles for the user

        await setRoleMode(user.value!.uid, false);
      }

      if (!user.value!.emailVerified) {
        await user.value!.sendEmailVerification(
            // ActionCodeSettings(
            //   url:
            //       'https://dropsride.page.link/verify-email/', // Update with your app's dynamic link domain
            //   androidPackageName:
            //       'com.dropsride.android', // Update with your app's package name
            //   iOSBundleId:
            //       'com.dropsride.apple', // Update with your app's bundle ID
            //   handleCodeInApp: true,
            //   androidInstallApp: true,
            //   androidMinimumVersion: '19',
            // ),
            );

        // Start the timer to periodically check email verification status
        verificationTimer.value =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          checkEmailVerificationStatus(user);
        });

        showInfoMessage(
            'Email Verification Sent',
            'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
            Icons.email_rounded);

        if (!isEmailVerified.value) {
          Get.bottomSheet(
            backgroundColor:
                Theme.of(Get.context!).colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.padding),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  hSizedBox4,
                  Text(
                    'Verification Processing?',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          fontWeight: FontWeight.w900,
                          color:
                              Theme.of(Get.context!).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox2,
                  Text(
                    'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
                    style:
                        Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                              letterSpacing: 1,
                            ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: !user.value!.emailVerified ? true : false,
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 16.0),
                  Divider(
                    height: AppSizes.p18 * 2.8,
                    color: Theme.of(Get.context!).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          );
        }

        isLoading.value = false;
        return;
      }
      showSuccessMessage(
          'Authenticated',
          'You successfully logged into your account: **$emailInput**',
          Icons.face_unlock_sharp);
      isLoading.value = false;
      return Get.off(
        () {
          const LegalPage();
        },
        duration: const Duration(milliseconds: 1200),
        transition: Transition.rightToLeftWithFade,
      );
    }

    isLoading.value = false;
    return;
  }

  // Facebook sign in button function
  Future<void> signInWithFacebook() async {
    isLoading.value = true;

    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final credential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    if (credential.user != null) {
      user = Rx<User?>(credential.user);

      if (!login.value) {
        // link the credentials with the user
        try {
          await FirebaseAuth.instance.currentUser
              ?.reauthenticateWithCredential(facebookAuthCredential);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "provider-already-linked":
              var message = "The provider has already been linked to the user.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "invalid-credential":
              var message = "The provider's credential is not valid.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "credential-already-in-use":
              var message =
                  "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            // See the API reference for the full list of error codes.
            default:
              var message = "Unknown error.";
              showErrorMessage("Account Linking", message, Icons.account_box);
          }
        }

        // if the user is not null create a default user and driver roles for the user

        await setRoleMode(user.value!.uid, false);
      }

      if (!user.value!.emailVerified) {
        await user.value!.sendEmailVerification(
            // ActionCodeSettings(
            //   url:
            //       'https://dropsride.page.link/verify-email/', // Update with your app's dynamic link domain
            //   androidPackageName:
            //       'com.dropsride.android', // Update with your app's package name
            //   iOSBundleId:
            //       'com.dropsride.apple', // Update with your app's bundle ID
            //   handleCodeInApp: true,
            //   androidInstallApp: true,
            //   androidMinimumVersion: '19',
            // ),
            );

        // Start the timer to periodically check email verification status
        verificationTimer.value =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          checkEmailVerificationStatus(user);
        });

        showInfoMessage(
          'Email Verification Sent',
          'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
          Icons.email_rounded,
        );

        if (!isEmailVerified.value) {
          Get.bottomSheet(
            backgroundColor:
                Theme.of(Get.context!).colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.padding),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  hSizedBox4,
                  Text(
                    'Verification Processing?',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          fontWeight: FontWeight.w900,
                          color:
                              Theme.of(Get.context!).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox2,
                  Text(
                    'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
                    style:
                        Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                              letterSpacing: 1,
                            ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: !user.value!.emailVerified ? true : false,
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 16.0),
                  Divider(
                    height: AppSizes.p18 * 2.8,
                    color: Theme.of(Get.context!).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          );
        }
      }
      showSuccessMessage(
          'Authenticated',
          'You successfully logged into your account: **$emailInput**',
          Icons.face_unlock_sharp);

      isLoading.value = false;
      return Get.off(
        () {
          const LegalPage();
        },
        duration: const Duration(milliseconds: 1200),
        transition: Transition.rightToLeftWithFade,
      );
    }

    isLoading.value = false;
    return;
  }

  // Generates a cryptographically secure random nonce, to be included in a
  // credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    isLoading.value = true;
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final credential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    if (credential.user != null) {
      user = Rx<User?>(credential.user);

      if (!login.value) {
        // link the credentials with the user
        try {
          await FirebaseAuth.instance.currentUser
              ?.reauthenticateWithCredential(oauthCredential);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "provider-already-linked":
              var message = "The provider has already been linked to the user.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "invalid-credential":
              var message = "The provider's credential is not valid.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            case "credential-already-in-use":
              var message =
                  "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
              showErrorMessage("Account Linking", message, Icons.account_box);

              break;
            // See the API reference for the full list of error codes.
            default:
              var message = "Unknown error.";
              showErrorMessage("Account Linking", message, Icons.account_box);
          }
        }

        // if the user is not null create a default user and driver roles for the user

        await setRoleMode(user.value!.uid, false);
      }

      if (!user.value!.emailVerified) {
        await user.value!.sendEmailVerification(
            // ActionCodeSettings(
            //   url:
            //       'https://dropsride.page.link/verify-email/', // Update with your app's dynamic link domain
            //   androidPackageName:
            //       'com.dropsride.android', // Update with your app's package name
            //   iOSBundleId:
            //       'com.dropsride.apple', // Update with your app's bundle ID
            //   handleCodeInApp: true,
            //   androidInstallApp: true,
            //   androidMinimumVersion: '19',
            // ),
            );

        // Start the timer to periodically check email verification status
        verificationTimer.value =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          checkEmailVerificationStatus(user);
        });

        showInfoMessage(
          'Email Verification Sent',
          'We have sent: **$emailInput** a verification email. Please confirm to proceed.',
          Icons.email_rounded,
        );

        if (!isEmailVerified.value) {
          Get.bottomSheet(
            backgroundColor:
                Theme.of(Get.context!).colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.padding),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  hSizedBox4,
                  Text(
                    'Verification Processing?',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          fontWeight: FontWeight.w900,
                          color:
                              Theme.of(Get.context!).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox2,
                  Text(
                    'Please wait for the verification process to complete. Once completed we will redirect you automatically.',
                    style:
                        Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                              letterSpacing: 1,
                            ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: !user.value!.emailVerified ? true : false,
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 16.0),
                  Divider(
                    height: AppSizes.p18 * 2.8,
                    color: Theme.of(Get.context!).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          );
        }
      }
      showSuccessMessage(
          'Authenticated',
          'You successfully logged into your account: **$emailInput**',
          Icons.face_unlock_sharp);

      isLoading.value = false;
      return Get.off(
        () {
          const LegalPage();
        },
        duration: const Duration(milliseconds: 1200),
        transition: Transition.rightToLeftWithFade,
      );
    }

    isLoading.value = false;
    return;
  }
}
