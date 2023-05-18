import 'package:dropsride/src/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get find => Get.find();

  RxBool login = false.obs;
  RxBool isLoading = false.obs;
  RxInt passwordScore = 0.obs;

  final formKey = GlobalKey<FormState>();

  String nameInput = '';
  String emailInput = '';
  String passwordInput = '';

  void toggleForm() => login.value = !login.value;

  void passwordStrength(int score) => passwordScore.value = score;

  void validateFields() => formKey.currentState!.validate();

  void checkPasswordStrength(value) {
    if (!validateRequired(value)) {
      passwordStrength(0);
    } else if (validateRequired(value) &&
        validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8) &&
        passwordHasSpecialCharacter(value) &&
        passwordHasNumber(value) &&
        passwordHasUppercaseLetter(value)) {
      passwordStrength(4);
    } else if (validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8) &&
        passwordHasSpecialCharacter(value) &&
        passwordHasNumber(value)) {
      passwordStrength(3);
    } else if (validateMinimumLength(value, 6) &&
        validateMinimumLength(value, 8)) {
      passwordStrength(2);
    } else if (validateMinimumLength(value, 6)) {
      passwordStrength(1);
    }

    print(validateRequired(value));
    print(validateMinimumLength(value, 6));
    print(validateMinimumLength(value, 8));
    print(passwordHasSpecialCharacter(value));
    print(passwordHasNumber(value));
    print(passwordHasUppercaseLetter(value));
    print(passwordScore.value);
  }
}
