import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DestinationRepository extends GetxController {
  static DestinationRepository get instance => Get.put(DestinationRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = AuthenticationRepository.instance.firebaseUser.value;

  User? firebaseUser = AuthenticationRepository.instance.firebaseUser.value;

  createFavoriteDestination(FavouriteDestination location) async {
    if (AuthenticationRepository.instance.firebaseUser.value != null) {
      await _firestore
          .collection('users')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .collection('favorite_destination')
          .doc(
              "${AuthenticationRepository.instance.firebaseUser.value!.uid}-${DateTime.now().millisecondsSinceEpoch}")
          .set(location.toMap())
          .whenComplete(() {
        showSuccessMessage(
            'Location Created',
            'You have successfully created a new location',
            FontAwesomeIcons.location);
        AuthenticationRepository.instance.firebaseUser.value!.reload();
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
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .collection('favorite_destination')
          .doc(documentId)
          .update(location.toUpdateMap())
          .whenComplete(() {
        showSuccessMessage(
            'Location Created',
            'You have successfully updated your location',
            FontAwesomeIcons.location);
        AuthenticationRepository.instance.firebaseUser.value!.reload();
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

  Stream<FavouriteDestination> getSavedHomeDestination() {
    final snapshot = _firestore
        .collection('users')
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .snapshots();

    final destinations = snapshot.map((e) {
      return e.docs
          .where(
              (doc) => doc.id.contains(FirebaseAuth.instance.currentUser!.uid))
          .map((e) => FavouriteDestination.fromSnapshot(e))
          .where(
        (element) {
          if (element.title.contains('Home')) {
            return element.title.contains('Home');
          } else if (element.title.contains('home')) {
            return element.title.contains('home');
          } else if (element.title.contains('Family')) {
            return element.title.contains('Family');
          } else if (element.title.contains('family')) {
            return element.title.contains('family');
          } else {
            return element.title.contains('residence');
          }
        },
      ).single;
    });

    final userBank = destinations;

    return userBank;
  }

  Stream<FavouriteDestination> getSavedSchoolDestination() {
    final snapshot = _firestore
        .collection('users')
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .snapshots();

    final destinations = snapshot.map((e) {
      return e.docs
          .where(
              (doc) => doc.id.contains(FirebaseAuth.instance.currentUser!.uid))
          .map((e) => FavouriteDestination.fromSnapshot(e))
          .where(
        (element) {
          if (element.title.contains('University')) {
            return element.title.contains('University');
          } else if (element.title.contains('university')) {
            return element.title.contains('university');
          } else if (element.title.contains('Academy')) {
            return element.title.contains('Academy');
          } else if (element.title.contains('academy')) {
            return element.title.contains('academy');
          } else if (element.title.contains('School')) {
            return element.title.contains('School');
          } else if (element.title.contains('school')) {
            return element.title.contains('school');
          } else if (element.title.contains('Montessori')) {
            return element.title.contains('Montessori');
          } else if (element.title.contains('montessori')) {
            return element.title.contains('montessori');
          } else if (element.title.contains('Primary')) {
            return element.title.contains('Primary');
          } else if (element.title.contains('primary')) {
            return element.title.contains('primary');
          } else if (element.title.contains('Day Care')) {
            return element.title.contains('Day Care');
          } else if (element.title.contains('day care')) {
            return element.title.contains('day care');
          } else {
            return element.title.contains('college');
          }
        },
      ).single;
    });

    final userBank = destinations;

    return userBank;
  }

  Stream<FavouriteDestination> getSavedWorkDestination() {
    final snapshot = _firestore
        .collection('users')
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
        .collection('favorite_destination')
        .orderBy('addedOn', descending: true)
        .snapshots();

    final destinations = snapshot.map((e) {
      return e.docs
          .where(
              (doc) => doc.id.contains(FirebaseAuth.instance.currentUser!.uid))
          .map((e) => FavouriteDestination.fromSnapshot(e))
          .where(
        (element) {
          if (element.title.contains('Work')) {
            return element.title.contains('Work');
          } else if (element.title.contains('work')) {
            return element.title.contains('work');
          } else if (element.title.contains('Office')) {
            return element.title.contains('Office');
          } else if (element.title.contains('office')) {
            return element.title.contains('office');
          } else {
            return element.title.contains('job');
          }
        },
      ).single;
    });

    final userBank = destinations;

    return userBank;
  }

  Stream<List<FavouriteDestination>> getAllFavoriteDestination() {
    final snapshot = _firestore
        .collection('users')
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
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
