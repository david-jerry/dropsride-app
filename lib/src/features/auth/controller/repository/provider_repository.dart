import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/social_provider_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialProviderRepository extends AuthenticationRepository {
  static SocialProviderRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;

  // Google sign in button function
  Future<void> signInWithGoogle(bool login) async {
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

    // Once signed in, the binder will update the userChange state
    try {
      await _auth.signInWithCredential(googleCredential);
      AuthController.instance.isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      final ex = SocialExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
    }

    firebaseUser.value = _auth.currentUser;

    if (firebaseUser.value != null) {
      // check if signup screen is login
      if (!login) {
        // link the credentials with the user
        try {
          await _auth.currentUser
              ?.reauthenticateWithCredential(googleCredential);

          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: firebaseUser.value?.displayName,
            email: firebaseUser.value?.email,
            country: null,
            gender: null,
            isDriver: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            phoneNumber: null,
            acceptTermsAndCondition: true,
            photoUrl: firebaseUser.value?.photoURL,
          );

          await AuthenticationRepository.instance
              .createUserWithEmailAndPassword(
            modelUser.email!,
            modelUser.password!,
            modelUser.displayName!,
            modelUser.acceptTermsAndCondition,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);

          // Send a success alert
          showSuccessMessage(
              'Registration',
              "You have successfully created an account with this email address: ${firebaseUser.value!.email}",
              Icons.lock_person);

          // send verification email to the user if they are not null
          await EmailVerificationRepository.instance
              .sendVerification(firebaseUser.value!);

          AuthController.instance.isLoading.value = false;
        } on FirebaseAuthException catch (e) {
          final ex = SocialExceptions.code(e.code);
          showErrorMessage(
              "Authentication Error", ex.message, Icons.lock_person);
        } catch (_) {
          const ex = SocialExceptions();
          showErrorMessage(
              "Authentication Error", ex.message, Icons.lock_person);
        }
      }

      // if user email is not verified
      if (!firebaseUser.value!.emailVerified) {
        await EmailVerificationRepository.instance
            .sendVerification(firebaseUser.value!);
      } else {
        showSuccessMessage(
            'Authenticated',
            'You successfully logged into your account: **${firebaseUser.value!.email}**',
            Icons.face_unlock_sharp);

        Get.offAll(() => const HomeScreen(), transition: Transition.native);
      }
    }
  }

  // Facebook sign in button function
  Future<void> signInWithFacebook(bool login) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, the binder will update the userChange state
    try {
      _auth.signInWithCredential(facebookAuthCredential);
      AuthController.instance.isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      final ex = SocialExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
    }

    firebaseUser.value = _auth.currentUser;

    if (firebaseUser.value != null) {
      if (!login) {
        // link the credentials with the user
        try {
          await _auth.currentUser
              ?.reauthenticateWithCredential(facebookAuthCredential);

          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: firebaseUser.value?.displayName,
            email: firebaseUser.value?.email,
            country: null,
            gender: null,
            isDriver: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            phoneNumber: null,
            acceptTermsAndCondition: true,
            photoUrl: firebaseUser.value?.photoURL,
          );

          await AuthenticationRepository.instance
              .createUserWithEmailAndPassword(
            modelUser.email!,
            modelUser.password!,
            modelUser.displayName!,
            modelUser.acceptTermsAndCondition,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);
          showSuccessMessage(
              'Registration',
              "You have successfully created an account with this email address: ${firebaseUser.value!.email}",
              Icons.lock_person);

          // send verification email to the user if they are not null
          await EmailVerificationRepository.instance
              .sendVerification(firebaseUser.value!);

          AuthController.instance.isLoading.value = false;
        } on FirebaseAuthException catch (e) {
          final ex = SocialExceptions.code(e.code);
          showErrorMessage(
              "Authentication Error", ex.message, Icons.lock_person);
        }
      }

      // if user email is not verified
      if (!firebaseUser.value!.emailVerified) {
        await EmailVerificationRepository.instance
            .sendVerification(firebaseUser.value!);
      } else {
        showSuccessMessage(
            'Authenticated',
            'You successfully logged into your account: **${firebaseUser.value!.email}**',
            Icons.face_unlock_sharp);

        Get.offAll(() => const HomeScreen(), transition: Transition.native);
      }
    }
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

  Future<void> signInWithApple(bool login) async {
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
    try {
      await _auth.signInWithCredential(oauthCredential);
      AuthController.instance.isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      final ex = SocialExceptions.code(e.code);
      showErrorMessage("Authentication Error", ex.message, Icons.lock_person);
    }

    firebaseUser.value = _auth.currentUser;

    if (firebaseUser.value != null) {
      if (!login) {
        // link the credentials with the user
        try {
          await _auth.currentUser
              ?.reauthenticateWithCredential(oauthCredential);

          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: firebaseUser.value?.displayName,
            email: firebaseUser.value?.email,
            country: null,
            gender: null,
            isDriver: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            phoneNumber: null,
            acceptTermsAndCondition: true,
            photoUrl: firebaseUser.value?.photoURL,
          );

          await AuthenticationRepository.instance
              .createUserWithEmailAndPassword(
            modelUser.email!,
            modelUser.password!,
            modelUser.displayName!,
            modelUser.acceptTermsAndCondition,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);

          showSuccessMessage(
              'Registration',
              "You have successfully created an account with this email address: ${firebaseUser.value!.email}",
              Icons.lock_person);

          // send verification email to the user if they are not null
          await EmailVerificationRepository.instance
              .sendVerification(firebaseUser.value!);

          AuthController.instance.isLoading.value = false;
        } on FirebaseAuthException catch (e) {
          final ex = SocialExceptions.code(e.code);
          showErrorMessage(
              "Authentication Error", ex.message, Icons.lock_person);
        }
      }

      // if user email is not verified
      if (!firebaseUser.value!.emailVerified) {
        await EmailVerificationRepository.instance
            .sendVerification(firebaseUser.value!);
      } else {
        showSuccessMessage(
            'Authenticated',
            'You successfully logged into your account: **${firebaseUser.value!.email}**',
            Icons.face_unlock_sharp);

        Get.offAll(() => const HomeScreen(), transition: Transition.native);
      }
    }
  }
}
