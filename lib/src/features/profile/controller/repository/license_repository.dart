import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/license_controller.dart';
import 'package:dropsride/src/features/profile/model/drivers_license_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LicenseRepository extends GetxController {
  static LicenseRepository get instance => Get.put(LicenseRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? firebaseUser = AuthController.find.user.value;

  Future<void> addLicensePhotos(DriverLicenseModel licenseModel) async {
    LicenseController.instance.isLoading.value = true;
    if (firebaseUser != null) {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
          .collection('driver_license')
          .doc(AuthController.find.user.value!.uid)
          .set(licenseModel.toMap())
          .catchError(
        (error, stackTrace) {
          showErrorMessage('Update Error', error.toString(),
              FontAwesomeIcons.driversLicense);
          LicenseController.instance.isLoading.value = false;
          return;
        },
      );
    }
  }

  Future<DriverLicenseModel> getUserLicense(User user) async {
    final license = await _firestore
        .collection('users')
        .doc(AuthController.find.user.value!.uid)
        .collection('driver_license')
        .where(FieldPath.documentId, isEqualTo: user.uid)
        .get();

    final userLicense = license.docs
        .map(
          (e) => DriverLicenseModel.fromSnapshot(e),
        )
        .single;

    return userLicense;
  }
}
