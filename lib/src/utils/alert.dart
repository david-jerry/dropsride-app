import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInfoMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false);
  }
  Get.snackbar(
    title,
    icon: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        color: AppColors.whiteColor,
        size: AppSizes.padding * 3.5,
      ),
    ),
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.white100,
    message,
    borderRadius: AppSizes.p4,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    backgroundColor: Colors.blueAccent,
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: true,
    snackStyle: SnackStyle.FLOATING,
    isDismissible: true,
  );
}

void showSuccessMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false);
  }
  Get.snackbar(
    isDismissible: true,
    icon: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        color: AppColors.whiteColor,
        size: AppSizes.padding * 3.5,
      ),
    ),
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.white100,
    borderRadius: AppSizes.p4,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: Colors.greenAccent,
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: true,
    snackStyle: SnackStyle.FLOATING,
  );
}

void showWarningMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false);
  }
  Get.snackbar(
    isDismissible: true,
    icon: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        color: AppColors.secondaryColor,
        size: AppSizes.padding * 3.5,
      ),
    ),
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.secondaryColor,
    borderRadius: AppSizes.p4,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: Colors.yellowAccent,
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: true,
    snackStyle: SnackStyle.FLOATING,
  );
}

void showErrorMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false);
  }
  Get.snackbar(
    icon: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        color: AppColors.whiteColor,
        size: AppSizes.padding * 3.5,
      ),
    ),
    shouldIconPulse: true,
    isDismissible: true,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    borderRadius: AppSizes.p4,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: Colors.redAccent,
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: true,
    snackStyle: SnackStyle.FLOATING,
  );
}
