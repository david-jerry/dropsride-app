import 'dart:io';

import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/profile/view/profile_screen.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // ! form loading state
  RxBool isLoading = false.obs;

  // ! to pick images
  final _imagePicker = ImagePicker();
  Rx<File?> imagePreview = Rx<File?>(null);

  // ! input controllers
  RxString email = ''.obs;
  RxString displayName = ''.obs;
  Rx<PhoneNumberMap?> phoneNumber = PhoneNumberMap(
          countryISOCode: 'NG', countryCode: '+234', number: '7012345678')
      .obs;
  RxString country = ''.obs;
  Rx<DateTime> dateOfBirth = DateTime.now().obs;
  Rx<Gender?> gender = Rx<Gender>(Gender.gender);
  // RxString photoUrl = ''.obs;

  // ! validate fields
  void validateFields(GlobalKey<FormState> formKey) {
    FocusScope.of(Get.context!).unfocus();
    if (formKey.currentState == null) {
      return;
    }
    formKey.currentState!.validate();
  }

  getUserData(String email) {
    if (email.isEmail) {
      return UserRepository.instance.getUserDetails(email);
    } else {
      if (AuthenticationRepository.instance.firebaseUser.value != null) {
        showErrorMessage(
            'Internal Server Error',
            'We were unable to fetch the user data. Please check your connection and retry again. However if the error persists, please contact support@dropsride.com',
            FontAwesomeIcons.server);
      }

      print('Error showing the user detail');
      return;
    }
  }

  takePicture() async {
    isLoading.value = true;
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 600,
    );

    if (pickedImage == null) {
      isLoading.value = false;
      return;
    }

    File? imageFilePreview = File(pickedImage.path);
    imagePreview.value = imageFilePreview;
    updateUserPhoto(imageFilePreview);
  }

  updateUser(GlobalKey<FormState> formKey) async {
    isLoading.value = true;

    // check form validity first
    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Update Warning',
          "You must validate all necessary fields before submitting!",
          Icons.key_sharp);

      isLoading.value = false;
      return;
    }

    formKey.currentState!.save();

    final user = UserModel(
      displayName: displayName.value,
      phoneNumber: phoneNumber.value,
      dateOfBirth: dateOfBirth.value,
      country: country.value,
      gender: gender.value,
    );

    await UserRepository.instance.updateUserDetails(user);

    showSuccessMessage(
        'User Firestore',
        'Successfully added a new collection to the user database.',
        FontAwesomeIcons.userPlus);
    Get.to(() => const ProfileScreen());

    isLoading.value = false;
    return;
  }

  updateUserPhoto(File? selectedImage) async {
    isLoading.value = true;

    if (selectedImage == null) {
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
        .child('profile_images')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpeg');

    await storageRef.putFile(selectedImage);
    String photoUrl = await storageRef.getDownloadURL();

    final user = UserModel(
      photoUrl: photoUrl,
    );

    await UserRepository.instance.updateUserPhoto(user);

    isLoading.value = false;
    return;
  }

  Future<List<UserModel>> getAllActiveDrivers() async {
    return await UserRepository.instance.getAllDrivers();
  }
}
