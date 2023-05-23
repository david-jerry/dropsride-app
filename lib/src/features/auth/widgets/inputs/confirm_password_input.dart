import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordInputFields extends StatelessWidget {
  ConfirmPasswordInputFields({
    super.key,
    required this.aController,
    required this.controller,
    required this.inputType,
    required this.name,
  });

  final ThemeModeController controller;
  TextInputType inputType;
  String name;

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: Theme.of(context).colorScheme.onSecondaryContainer),
      enableSuggestions: true,
      enableIMEPersonalizedLearning: false,
      obscureText: true,
      obscuringCharacter: '*',
      keyboardType: inputType,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (!validateRequired(value!)) {
          return "This field is required!";
        }

        if (!validateMinimumLength(value, 6)) {
          return "Minimum allowed character is 6!";
        }

        if (!passwordHasNumber(value)) {
          return "Your password must have at least 1 integer!";
        }

        if (!passwordHasSpecialCharacter(value)) {
          return "Your password must have at least 1 special character!";
        }

        if (!passwordHasUppercaseLetter(value)) {
          return "Password must have at least 1 uppercase letter!";
        }

        if (value != aController.passwordInput.value) {
          return "Password do not match.";
        }

        return null;
      },
      // onChanged: (value) => aController.validateFields(),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        aController.validateFields();
      },
      onSaved: (newValue) => aController.confirmPasswordInput.value = newValue!,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.key_sharp,
          size: AppSizes.iconSize,
        ),
        label: Text(name),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.margin,
          ),
          borderSide: const BorderSide(
              width: AppSizes.p2, color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.margin,
          ),
          borderSide:
              const BorderSide(width: AppSizes.p2, color: AppColors.red),
        ),
      ),
    );
  }
}
