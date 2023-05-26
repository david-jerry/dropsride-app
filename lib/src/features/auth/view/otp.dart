import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/submit_button.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  final AuthController aController = Get.put(AuthController());
  final ThemeModeController controller = Get.find<ThemeModeController>();
  final TextEditingController tController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String initialCountry = 'NG';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.padding * 2,
            AppSizes.padding * 8,
            AppSizes.padding * 2,
            AppSizes.padding,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CO\nDE',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: AppSizes.iconSize * 4,
                          letterSpacing: 14,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  wSizedBox4,
                  // form heading
                  Text(
                    "Verification",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox6,
                  Text(
                    textAlign: TextAlign.center,
                    'Please enter the code sent to your phone number below to complete the verification.',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.3,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
            
                  Divider(
                    height: AppSizes.p18 * 4,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            
                  // input for the email and phone
                  OtpTextField(
                    numberOfFields: 6,
                    filled: true,
                    onSubmit: (value) {
                      aController.otp.value = value;
                      aController.completeOTP(value);
                    },
                    fillColor: Theme.of(context).colorScheme.onSecondary,
                  ),
            
                  // Submit the verification email or otp
                  hSizedBox4,
                  SubmitButton(
                      aController: aController,
                      onPressed: () {
                        return aController.completeOTP(aController.otp.value);
                      },
                      buttonText: 'Next'),
            
                  hSizedBox2,
            
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Resend OTP'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
