import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInfoMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false, canPop: true);
  }
  Get.snackbar(
    title,
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding * 1.4),
      child: Icon(
        icon,
        color: Colors.blue,
        size: AppSizes.padding * 1.4,
      ),
    ),
    shouldIconPulse: false,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.secondaryColor,
    message,
    borderRadius: AppSizes.padding * 3,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    backgroundColor: const Color.fromARGB(255, 182, 222, 255),
    padding: const EdgeInsets.all(AppSizes.padding) * 1.2,
    showProgressIndicator: false,
    snackStyle: SnackStyle.GROUNDED,
    isDismissible: true,
  );
}

void showSuccessMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false, canPop: true);
  }
  Get.snackbar(
    isDismissible: true,
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding * 1.4),
      child: Icon(
        icon,
        color: AppColors.green,
        size: AppSizes.padding * 1.4,
      ),
    ),
    shouldIconPulse: false,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.secondaryColor,
    borderRadius: AppSizes.padding * 3,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: const Color.fromARGB(255, 202, 255, 217),
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: false,
    snackStyle: SnackStyle.GROUNDED,
  );
}

void showWarningMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false, canPop: true);
  }
  Get.snackbar(
    isDismissible: true,
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding * 1.4),
      child: Icon(
        icon,
        color: AppColors.secondaryColor,
        size: AppSizes.padding * 1.4,
      ),
    ),
    shouldIconPulse: false,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.secondaryColor,
    borderRadius: AppSizes.padding * 3,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: Colors.yellowAccent[100],
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: false,
    snackStyle: SnackStyle.GROUNDED,
  );
}

void showErrorMessage(String title, String message, IconData icon) {
  if (Get.isSnackbarOpen) {
    Get.back(closeOverlays: false, canPop: true);
  }
  Get.snackbar(
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding * 1.4),
      child: Icon(
        icon,
        color: AppColors.red,
        size: AppSizes.padding * 1.4,
      ),
    ),
    shouldIconPulse: false,
    isDismissible: true,
    snackPosition: SnackPosition.BOTTOM,
    colorText: AppColors.secondaryColor,
    borderRadius: AppSizes.padding * 3,
    dismissDirection: DismissDirection.down,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(milliseconds: 7500),
    title,
    message,
    backgroundColor: Colors.redAccent[100],
    padding: const EdgeInsets.all(AppSizes.padding) * 1.7,
    showProgressIndicator: false,
    snackStyle: SnackStyle.GROUNDED,
  );
}
