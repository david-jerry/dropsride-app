import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/exceptions/signup_exceptions.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/auth/controller/repository/email_verification_repository.dart';
import 'package:dropsride/src/features/auth/view/email_verification_screen.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialProviderRepository extends AuthenticationRepository {
  static SocialProviderRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  // Google sign in button function
  Future<void> signInWithGoogle(bool login) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      _auth.signInWithCredential(googleCredential).then((value) async {
        final DocumentSnapshot userSnapshot =
            await firebase.collection('users').doc(value.user!.uid).get();
        if (!userSnapshot.exists) {
          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: value.user!.displayName,
            email: value.user!.email,
            country: null,
            gender: null,
            isDriver: false,
            isSubscribed: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            acceptTermsAndCondition: true,
            photoUrl: value.user!.photoURL,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);
          await value.user?.reauthenticateWithCredential(googleCredential);

          showSuccessMessage(
              'Authenticated',
              'You successfully logged into your account: **${value.user!.email}**',
              Icons.face_unlock_sharp);
        }
      }).whenComplete(() async {
        if (!_auth.currentUser!.emailVerified) {
          await EmailVerificationRepository.instance
              .sendVerification(_auth.currentUser!);
          Get.offAll(() => const EmailVerificationScreen());
        }

        AssistantMethods.readOnlineUserCurrentInfo();
        AuthController.find.getNewMarkers.value = true;
        MapController.find.onBuildCompleted();
        await DestinationController.instance.getCurrentLocation();

        Future.delayed(const Duration(milliseconds: 6500), () {
          Get.offAll(() => const HomeScreen());
        });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("GoogleAuth Error", ex.message, FontAwesomeIcons.google);
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
      _auth.signInWithCredential(facebookAuthCredential).then((value) async {
        final DocumentSnapshot userSnapshot =
            await firebase.collection('users').doc(value.user!.uid).get();
        if (!userSnapshot.exists) {
          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: value.user!.displayName,
            email: value.user!.email,
            country: null,
            gender: null,
            isDriver: false,
            isSubscribed: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            acceptTermsAndCondition: true,
            photoUrl: value.user!.photoURL,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);
          await value.user
              ?.reauthenticateWithCredential(facebookAuthCredential);

          showSuccessMessage(
              'Authenticated',
              'You successfully logged into your account: **${value.user!.email}**',
              Icons.face_unlock_sharp);
        }
      }).whenComplete(() async {
        if (!_auth.currentUser!.emailVerified) {
          await EmailVerificationRepository.instance
              .sendVerification(_auth.currentUser!);
          Get.offAll(() => const EmailVerificationScreen());
        }

        AssistantMethods.readOnlineUserCurrentInfo();
        AuthController.find.getNewMarkers.value = true;
        MapController.find.onBuildCompleted();
        await DestinationController.instance.getCurrentLocation();

        Future.delayed(const Duration(milliseconds: 6500), () {
          Get.offAll(() => const HomeScreen());
        });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("GoogleAuth Error", ex.message, FontAwesomeIcons.google);
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
      _auth.signInWithCredential(oauthCredential).then((value) async {
        final DocumentSnapshot userSnapshot =
            await firebase.collection('users').doc(value.user!.uid).get();
        if (!userSnapshot.exists) {
          // store the information to the userModel class
          final modelUser = UserModel(
            displayName: value.user!.displayName,
            email: value.user!.email,
            country: null,
            gender: null,
            isDriver: false,
            isSubscribed: false,
            isVerified: false,
            joinedOn: DateTime.now(),
            password: DateTime.now().millisecondsSinceEpoch.toString(),
            acceptTermsAndCondition: true,
            photoUrl: value.user!.photoURL,
          );

          // store the information to firebase
          await UserRepository.instance.createFirestoreUser(modelUser);
          await value.user?.reauthenticateWithCredential(oauthCredential);

          showSuccessMessage(
              'Authenticated',
              'You successfully logged into your account: **${value.user!.email}**',
              Icons.face_unlock_sharp);
        }
      }).whenComplete(() async {
        if (!_auth.currentUser!.emailVerified) {
          await EmailVerificationRepository.instance
              .sendVerification(_auth.currentUser!);
          Get.offAll(() => const EmailVerificationScreen());
        }

        AssistantMethods.readOnlineUserCurrentInfo();
        AuthController.find.getNewMarkers.value = true;
        MapController.find.onBuildCompleted();
        await DestinationController.instance.getCurrentLocation();

        Future.delayed(const Duration(milliseconds: 6500), () {
          Get.offAll(() => const HomeScreen());
        });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordExceptions.code(e.code);
      showErrorMessage("GoogleAuth Error", ex.message, FontAwesomeIcons.google);
    }
  }
}
