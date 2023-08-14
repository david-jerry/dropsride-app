import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.aController,
  });

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: true,
      initialValue: FirebaseAuth.instance.currentUser != null
          ? FirebaseAuth.instance.currentUser!.phoneNumber
          : null,
      inputFormatters: [MaskedInputFormatter('000 000 0000')],
      onChanged: (value) {
        aController.phoneNumber.value = PhoneNumberMap(
          countryCode: value.countryCode,
          countryISOCode: value.countryISOCode,
          number: value.number,
        );
      },
      flagsButtonMargin: const EdgeInsets.all(12),
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: false),
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: Theme.of(context).colorScheme.onSecondaryContainer),
      initialCountryCode: "NG",
      // countries: const [
      //   'NG',
      //   'GH',
      //   'US',
      // ],
      decoration: InputDecoration(
        labelText: 'Phone',
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
