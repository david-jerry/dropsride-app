import 'dart:io';

import 'package:dropsride/src/features/profile/controller/repository/license_repository.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/drivers_license_model.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LicenseController extends GetxController {
  static LicenseController get instance => Get.put(LicenseController());

  RxBool firstCapture = true.obs;
  final _imagePicker = ImagePicker();
  final _imageLicensePicker = ImagePicker();
  Rx<File?> imagePreview = Rx<File?>(null);
  Rx<File?> imageLicensePreview = Rx<File?>(null);

  RxBool isLoading = true.obs;
  RxInt approved = 1.obs;

  takeLicenseOwnerPicture() async {
    isLoading.value = true;
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: SizeConfig.screenHeight * 0.45,
    );

    if (pickedImage == null) {
      isLoading.value = false;
      return;
    }

    File? imageFilePreview = File(pickedImage.path);
    imagePreview.value = imageFilePreview;
  }

  takeLicensePicture() async {
    isLoading.value = true;
    final pickedImage = await _imageLicensePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: SizeConfig.screenHeight * 0.3,
    );

    if (pickedImage == null) {
      isLoading.value = false;
      return;
    }

    File? imageLicenseFilePreview = File(pickedImage.path);
    imageLicensePreview.value = imageLicenseFilePreview;
  }

  updateLicensePhoto(File? selectedImage, File? licenseImage) async {
    isLoading.value = true;

    if (selectedImage == null || licenseImage == null) {
      showWarningMessage('Image Upload',
          'You need to select an image first to upload.', Icons.camera);
      isLoading.value = false;
      return;
    }

    if (FirebaseAuth.instance.currentUser == null) {
      showWarningMessage('Image Upload',
          'You need to be authenticated to upload an image.', Icons.camera);
      isLoading.value = false;
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('drivers_license_images')
        .child('${FirebaseAuth.instance.currentUser!.uid}-holder.jpeg');
        
    final storageLicenseRef = FirebaseStorage.instance
        .ref()
        .child('drivers_license_images')
        .child('${FirebaseAuth.instance.currentUser!.uid}-license.jpeg');

    await storageRef.putFile(selectedImage);
    await storageLicenseRef.putFile(licenseImage);
    String photoUrlHolder = await storageRef.getDownloadURL();
    String photoUrlLicense = await storageLicenseRef.getDownloadURL();

    final userLicense = DriverLicenseModel(
      holder: photoUrlHolder,
      license: photoUrlLicense,
    );

    await LicenseRepository.instance.addLicensePhotos(userLicense);

    isLoading.value = false;
    return;
  }
}
