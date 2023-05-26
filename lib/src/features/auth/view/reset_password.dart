import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/submit_button.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/confirm_password_input.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/password_input.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
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
                  SvgPicture.asset(
                    Assets.assetsImagesSvgResetPasswordSvg,
                    width: SizeConfig.screenWidth * (1 / 1.5),
                  ),
                  wSizedBox4,
                  // form heading
                  Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox6,
                  Text(
                    textAlign: TextAlign.center,
                    'Add a new password here so to improve your security.',
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
                  PasswordInputFields(
                    aController: aController,
                    controller: controller,
                    inputType: TextInputType.visiblePassword,
                    name: 'New Password',
                    formKey: _formKey,
                  ),
                  hSizedBox2,
                  ConfirmPasswordInputFields(
                    aController: aController,
                    controller: controller,
                    inputType: TextInputType.visiblePassword,
                    name: 'Confirm New Password',
                    formKey: _formKey,
                  ),

                  // Submit the verification email or otp
                  hSizedBox4,
                  SubmitButton(
                      aController: aController,
                      onPressed: () {
                        return aController.completePasswordReset();
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
