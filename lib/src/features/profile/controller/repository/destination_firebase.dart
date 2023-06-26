import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DestinationRepository extends GetxController {
  static DestinationRepository get instance => Get.put(DestinationRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = AuthController.find.user.value;

  User? firebaseUser = AuthController.find.user.value;

  createFavoriteDestination(FavouriteDestination location) async {
    if (AuthController.find.user.value != null) {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
          .collection('favorite_destination')
          .doc(
              "${AuthController.find.user.value!.uid}-${DateTime.now().millisecondsSinceEpoch}")
          .set(location.toMap())
          .whenComplete(() {
        showSuccessMessage(
            'Location Created',
            'You have successfully created a new location',
            FontAwesomeIcons.location);
        AuthController.find.user.value!.reload();
      }).catchError((error, stackTrace) {
        showErrorMessage(
            'User Firestore', error.toString(), FontAwesomeIcons.location);
      });
    } else {
      showWarningMessage(
          'Authentication Warning',
          "Only Authenticated users can store favorite destinations",
          FontAwesomeIcons.location);
    }
  }

  Future<void> updateFavoriteDestination(
      FavouriteDestination location, String documentId) async {
    ProfileController.instance.isLoading.value = true;
    if (firebaseUser != null) {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
          .collection('favorite_destination')
          .doc(documentId)
          .update(location.toUpdateMap())
          .whenComplete(() {
        showSuccessMessage(
            'Location Created',
            'You have successfully updated your location',
            FontAwesomeIcons.location);
        AuthController.find.user.value!.reload();
      }).catchError(
        (error, stackTrace) {
          showErrorMessage(
              'Update Error', error.toString(), FontAwesomeIcons.location);
          ProfileController.instance.isLoading.value = false;
          return;
        },
      );
    }
  }

  Future<FavouriteDestination?> getSavedHomeDestination() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    FavouriteDestination? userBank;

    for (final doc in snapshot.docs) {
      final element = doc['title'];

      if (element.contains('Home')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('home')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Family')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('family')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      }
    }

    return userBank;
  }

  Future<FavouriteDestination?> getSavedSchoolDestination() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(AuthController.find.user.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    FavouriteDestination? userBank;

    for (final doc in snapshot.docs) {
      final element = doc['title'];

      if (element.contains('University')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('university')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Academy')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('academy')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('School')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('school')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Montessori')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('montessori')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Primary')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('primary')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Day Care')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('day care')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      }
    }

    return userBank;
  }

  Future<FavouriteDestination?> getSavedWorkDestination() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(AuthController.find.user.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    FavouriteDestination? userBank;

    for (final doc in snapshot.docs) {
      final element = doc['title'];

      if (element.contains('Work')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('work')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('Office')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      } else if (element.contains('office')) {
        userBank = FavouriteDestination.fromSnapshot(doc);
        break;
      }
    }

    return userBank;
  }

  Stream<List<FavouriteDestination>> getAllFavoriteDestination() {
    final snapshot = _firestore
        .collection('users')
        .doc(AuthController.find.user.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .snapshots();

    return snapshot.map((e) {
      return e.docs
          .where(
              (doc) => doc.id.contains(FirebaseAuth.instance.currentUser!.uid))
          .map((e) => FavouriteDestination.fromSnapshot(e))
          .toList();
    });

    // e.docs
    // .where(
    //     (doc) => doc.id.contains(FirebaseAuth.instance.currentUser!.uid))
    //       .map((e) => FavouriteDestination.fromSnapshot(e))
    //       .toList(),
  }
}
