import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/transaction/model/wallet_model.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? firebaseUser = AuthenticationRepository.instance.firebaseUser.value;

  createFirestoreUser(UserModel user) async {
    if (AuthenticationRepository.instance.firebaseUser.value != null) {
      await _firestore
          .collection('users')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .set(user.toMap())
          .whenComplete(() async {
        // create the user wallet at the same time the user is creating an account
        print('Creating account Successful');
        WalletBal walletBal = WalletBal();
        await _firestore
            .collection('users')
            .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
            .collection('wallet')
            .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
            .set(walletBal.toMap())
            .catchError(
          (error, stackTrace) {
            showErrorMessage('Wallet Record Error', error.toString(),
                FontAwesomeIcons.history);
            CardController.instance.isLoading.value = false;
            return;
          },
        );
        showSuccessMessage(
            'Account Created',
            'You have successfully created an account with this email address: ${AuthenticationRepository.instance.firebaseUser.value!.email}',
            FontAwesomeIcons.userInjured);
        AuthenticationRepository.instance.firebaseUser.value!.reload();
      }).catchError((error, stackTrace) {
        print('Creating account unSuccessful');
        showErrorMessage(
            'User Firestore', error.toString(), FontAwesomeIcons.userInjured);
        AuthenticationRepository.instance.firebaseUser.value!.delete();
        AuthenticationRepository.instance.firebaseUser.value!.reload();
      });
    }
  }

  Future<void> updateUserDetails(UserModel user) async {
    ProfileController.instance.isLoading.value = true;
    if (firebaseUser != null) {
      await _firestore
          .collection('users')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .update(user.updateDetailToMap())
          .catchError(
        (error, stackTrace) {
          showErrorMessage(
              'Update Error', error.toString(), FontAwesomeIcons.userSecret);
          ProfileController.instance.isLoading.value = false;
          return;
        },
      );
    }
  }

  Future<void> updateUserPhoto(UserModel user) async {
    ProfileController.instance.isLoading.value = true;
    if (firebaseUser != null) {
      await _firestore
          .collection('users')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .update(user.updatePhotoToMap())
          .catchError(
        (error, stackTrace) {
          showErrorMessage(
              'Update Error', error.toString(), FontAwesomeIcons.userSecret);
          ProfileController.instance.isLoading.value = false;
          return;
        },
      );
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .single;
    return userData;
  }

  Future<List<UserModel>> getAllDrivers() async {
    final snapshot = await _firestore
        .collection('users')
        .where('isDriver', isEqualTo: true)
        .get();

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList();
    return userData;
  }
}
