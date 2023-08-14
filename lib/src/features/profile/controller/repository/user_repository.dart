import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/transaction/model/wallet_model.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find<UserRepository>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  createFirestoreUser(UserModel user) async {
    AuthController.find.user.value = FirebaseAuth.instance.currentUser;
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(user.toMap());
      } catch (e) {
        showErrorMessage(
            'User Firestore', e.toString(), FontAwesomeIcons.userInjured);
        FirebaseAuth.instance.currentUser!.delete();
        FirebaseAuth.instance.currentUser!.reload();
        FirebaseAuth.instance.signOut();
        return;
      }

      try {
        WalletBal walletBal = WalletBal();
        await _firestore
            .collection('users')
            .doc(AuthController.find.user.value!.uid)
            .collection('wallet')
            .doc(AuthController.find.user.value!.uid)
            .set(walletBal.toMap());
      } catch (e) {
        showErrorMessage(
            'Wallet Record Error', e.toString(), FontAwesomeIcons.history);
        CardController.instance.isLoading.value = false;
        return;
      }

      try {
        UserRating userRating = UserRating();
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('ratings')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set(userRating.toMap())
            .whenComplete(
          () async {
            AssistantMethods.readRatingInfo();
            return;
          },
        );
      } catch (e) {
        showErrorMessage(
            'User Rating Error', e.toString(), FontAwesomeIcons.star);
        return;
      }

      showSuccessMessage(
          'Account Created',
          'You have successfully created an account with this email address: ${AuthController.find.user.value!.email}',
          FontAwesomeIcons.userInjured);
      FirebaseAuth.instance.currentUser!.reload();
    }
  }

  Future<dynamic> getUserRideStatus(RideStatus status) async {
    // Reference to the Firestore collection "users"
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Reference to the specific document identified by UID in the "users" collection
    DocumentReference userDocRef =
        usersCollection.doc(AuthController.find.userModel.value!.uid);

    // Set the "newrideStatus" field to "idle" in the document
    await userDocRef.update({'rideStatus': status.name});

    // Listening to changes on the document (You can attach a snapshot listener)
    userDocRef.snapshots().listen((snapshot) {
      // Handle changes here, if necessary
    });
  }

  Future<void> updateUserDetails(UserModel user) async {
    ProfileController.instance.isLoading.value = true;
    if (AuthController.find.user.value != null) {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
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
    if (AuthController.find.user.value != null) {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
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

  getUserDetails(String email) async {
    print(email);
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) {
      FirebaseAuth.instance.signOut();
      return;
    }

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .single;
    return userData;
  }

  Future<dynamic> getCurrentUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      AuthController.find.signOutUser();
      return;
    }

    UserModel userData = UserModel.fromSnapshot(snapshot);
    return userData;
  }

  Future<int> getUserRating(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('ratings')
        .get();

    if (snapshot.docs.isEmpty) {
      return 5;
    }

    List<UserRating> userRating =
        snapshot.docs.map((e) => UserRating.fromSnapshot(e)).toList();
    List<int> ratingList = [];
    for (var element in userRating) {
      ratingList.add(element.rating!.round());
    }

    if (ratingList.isEmpty) return 5;
    int ratingSum = ratingList.reduce((value, element) => value + element);
    double averageRating = ratingSum / ratingList.length;
    return averageRating.round();
  }

  Future<void> addNewRating(String uid, UserRating rating) async {
    if (AuthController.find.user.value != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('rating')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(rating.toMap())
          .whenComplete(
        () async {
          AssistantMethods.readRatingInfo();
          return;
        },
      ).catchError((error, stackTrace) {
        showErrorMessage(
            'Rating Error', error.toString(), FontAwesomeIcons.star);
        return;
      });
    }
  }

  Future<List<UserModel>> getAllDrivers() async {
    final snapshot = await _firestore
        .collection('users')
        .where('isDriver', isEqualTo: true)
        .where('isSubscribed', isEqualTo: true)
        .where('isOnline', isEqualTo: true)
        .where('rideStatus', isEqualTo: RideStatus.idle.name)
        .where('longitude', isNotEqualTo: null)
        .where('latitude', isNotEqualTo: null)
        .get();

    // ? when the driver is picked make a request to get the drivers car detail to show the rider

    if (snapshot.docs.isEmpty) {
      return <UserModel>[];
    }

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList();
    return userData;
  }
}
