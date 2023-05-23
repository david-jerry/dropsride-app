import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/forgot_password_button.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/privacy_button.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/submit_button.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/toggle_form.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/confirm_password_input.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/email_input.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/password_input.dart';
import 'package:dropsride/src/features/auth/widgets/inputs/text_input.dart';
import 'package:dropsride/src/features/auth/widgets/passwords/password_strength.dart';
import 'package:dropsride/src/features/auth/widgets/providers/apple.dart';
import 'package:dropsride/src/features/auth/widgets/providers/facebook.dart';
import 'package:dropsride/src/features/auth/widgets/providers/google.dart';
import 'package:dropsride/src/utils/theme/controller/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final ThemeModeController controller = Get.find<ThemeModeController>();
  final AuthController aController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(
                () => Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.padding * 2,
                    AppSizes.padding * 3,
                    AppSizes.padding * 2,
                    0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // form heading
                      Text(
                        aController.login.value ? 'Login' : "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      hSizedBox2,
                      Text(
                        'Please enter your details',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.3,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),

                      Divider(
                        height: AppSizes.p18 * 4,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),

                      // form body with switching for sign up and login
                      Form(
                        key: aController.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // input fields
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible:
                                        aController.login.value ? false : true,
                                    child: TextInputFields(
                                      controller: controller,
                                      name: "Name",
                                      aController: aController,
                                      inputType: TextInputType.name,
                                    ),
                                  ),
                                ),
                                aController.login.value
                                    ? const SizedBox(
                                        height: 0,
                                      )
                                    : hSizedBox4,
                                EmailInputFields(
                                  controller: controller,
                                  name: "Email",
                                  aController: aController,
                                  inputType: TextInputType.emailAddress,
                                ),
                                hSizedBox4,
                                PasswordInputFields(
                                  aController: aController,
                                  controller: controller,
                                  inputType: TextInputType.visiblePassword,
                                  name: 'New Password',
                                ),
                                Visibility(
                                    visible:
                                        aController.login.value ? false : true,
                                    child: hSizedBox2),
                                Visibility(
                                  visible:
                                      aController.login.value ? false : true,
                                  child: ConfirmPasswordInputFields(
                                    aController: aController,
                                    controller: controller,
                                    inputType: TextInputType.visiblePassword,
                                    name: 'Confirm New Password',
                                  ),
                                ),
                                Visibility(
                                    visible:
                                        aController.login.value ? false : true,
                                    child: hSizedBox6),
                                Visibility(
                                    visible:
                                        aController.login.value ? false : true,
                                    child: PasswordStrength(
                                        aController: aController))
                              ],
                            ),

                            // privacy and submit button
                            hSizedBox2,
                            Visibility(
                                visible: aController.login.value ? false : true,
                                child: PrivacyButton(aController: aController)),

                            // forgot password button
                            aController.login.value
                                ? ForgotPasswordButton(
                                    aController: aController,
                                  )
                                : hSizedBox0,

                            // submit button
                            hSizedBox4,
                            SubmitButton(
                                aController: aController,
                                onPressed: aController.login.value
                                    ? aController.loginUser
                                    : aController.createNewUser,
                                buttonText: !aController.login.value
                                    ? aController.isLoading.value
                                        ? 'Loading...'
                                        : 'Sign Up'.toUpperCase()
                                    : aController.isLoading.value
                                        ? 'Loading...'
                                        : 'Login'.toUpperCase()),

                            // switch to login or sign up
                            hSizedBox4,
                            ToggleFormButton(aController: aController),

                            Divider(
                              height: AppSizes.p18 * 4,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),

                            // sign in with google
                            SignInWithGoole(aController: aController),
                            hSizedBox2,

                            // sign in with apple
                            LoginWIthApple(aController: aController),
                            hSizedBox2,

                            // sign in with facebook
                            LoginWithFacebook(aController: aController),
                            hSizedBox8
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
