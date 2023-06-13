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

  Future<void> updateFavoriteDestination(FavouriteDestination location) async {
    ProfileController.instance.isLoading.value = true;
    if (firebaseUser != null) {
      await _firestore
          .collection('users')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
          .collection('favorite_destination')
          .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
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
