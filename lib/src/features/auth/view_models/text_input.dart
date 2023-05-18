import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/validators.dart';
import 'package:flutter/material.dart';

class TextInputFields extends StatelessWidget {
  TextInputFields({
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
      keyboardType: inputType,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (!validateRequired(value!)) {
          return "This field is required";
        }

        if (!validateAlphabetsOnly(value)) {
          return "This field must be alphabets only";
        }

        return null;
      },
      onTapOutside: (event) => aController.validateFields(),
      onSaved: (newValue) => aController.nameInput = newValue!,
      decoration: InputDecoration(
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
