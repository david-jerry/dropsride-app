import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/vehicle/model/vehicle_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VehicleController extends GetxController {
  static VehicleController get instance => Get.put(VehicleController());

  RxBool isLoading = false.obs;
  final _imagePicker = ImagePicker();

  Rx<File?> vehicleFront = Rx<File?>(null);
  Rx<File?> vehicleBack = Rx<File?>(null);
  Rx<File?> vehicleProofOfOwnership = Rx<File?>(null);
  Rx<File?> vehicleRoadWorthiness = Rx<File?>(null);
  Rx<File?> vehicleRegistration = Rx<File?>(null);
  RxString carColor = "".obs;
  RxString carModel = "".obs;
  RxString carPlateNumber = "".obs;

  takeVehicleFrontPicture() async {
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
    vehicleFront.value = imageFilePreview;
  }

  takeVehicleBackPicture() async {
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
    vehicleBack.value = imageFilePreview;
  }

  takeVehicleProofOfOwnershipPicture() async {
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
    vehicleProofOfOwnership.value = imageFilePreview;
  }

  takeVehicleRoadWorthinessPicture() async {
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
    vehicleRoadWorthiness.value = imageFilePreview;
  }

  takeVehicleRegistrationPicture() async {
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
    vehicleRegistration.value = imageFilePreview;
  }

  Future<List<String>> updateVehiclePapers() async {
    isLoading.value = true;

    if (FirebaseAuth.instance.currentUser == null) {
      showWarningMessage('Image Upload',
          'You need to be authenticated to upload an image.', Icons.camera);
      isLoading.value = false;
      return [];
    }

    if (vehicleFront.value == null ||
        vehicleBack.value == null ||
        vehicleProofOfOwnership.value == null ||
        vehicleRoadWorthiness.value == null ||
        vehicleRegistration.value == null) {
      showWarningMessage(
          'Image Upload',
          'You need to select all required image first before you can upload.',
          Icons.camera);
      isLoading.value = false;
      return [];
    }

    List<File> images = [
      vehicleFront.value!,
      vehicleBack.value!,
      vehicleProofOfOwnership.value!,
      vehicleRoadWorthiness.value!,
      vehicleRegistration.value!
    ];

    List<String> imageUrls = [];

    for (int i = 0; i < images.length; i++) {
      File imageFIle = images[i];
      String filename =
          "${FirebaseAuth.instance.currentUser!.uid}_${i.toString()}";

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('drivers_vehicle_papers')
          .child('$filename.jpeg');

      await storageRef.putFile(imageFIle);
      String photoUrlHolder = await storageRef.getDownloadURL();

      imageUrls.add(photoUrlHolder);
    }

    return imageUrls;
  }

  void saveVehiclePapers(List<String> imageUrls) {
    if (imageUrls.length < 5) {
      showErrorMessage(
          "Upload Error",
          "You need to submit all required documents to register your vehicle online",
          FontAwesomeIcons.car);
      isLoading.value = false;
      return;
    }

    VehicleModel vehicle = VehicleModel(
      carColor: carColor.value,
      carModel: carModel.value,
      carPlateNumber: carPlateNumber.value,
      imageUrls: imageUrls,
      verified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('vehicle_papers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(vehicle.toMap());
  }
}
