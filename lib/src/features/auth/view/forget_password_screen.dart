import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/submit_button.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/email_input.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/phone_input.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final AuthController aController = AuthController.instance;
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
            AppSizes.padding * 4,
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
                    Assets.assetsImagesSvgForgotPasswordSvg,
                    width: SizeConfig.screenWidth * (1 / 1.5),
                  ),
                  wSizedBox4,
                  // form heading
                  Text(
                    aController.forgotPasswordEmail.value
                        ? 'Email Reset'
                        : "Phone Reset",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox6,
                  Text(
                    textAlign: TextAlign.center,
                    aController.forgotPasswordEmail.value
                        ? 'Please enter your email address below to be emailed the password reset link.'
                        : 'Please enter your phone number below to receive the OTP for the password reset link.',
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
                  SizedBox(
                    width: double.maxFinite,
                    child: aController.forgotPasswordEmail.value
                        ? EmailInputFields(
                            aController: aController,
                            controller: controller,
                            inputType: TextInputType.emailAddress,
                            name: 'Email',
                            formKey: _formKey,
                          )
                        : PhoneInputField(aController: aController),
                  ),

                  // Submit the verification email or otp
                  hSizedBox4,
                  SubmitButton(
                    aController: aController,
                    onPressed: !aController.forgotPasswordEmail.value
                        ? aController.resetPasswordWithPhone
                        : aController.resetPasswordWithEmail,
                    buttonText:
                        aController.isLoading.value ? 'Loading...' : 'Verify',
                  ),

                  hSizedBox2,

                  TextButton(
                    onPressed: () {
                      aController.isLoading.value ? null : Get.back();
                    },
                    child: const Text('Cancel'),
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
