import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/view_models/email_input.dart';
import 'package:dropsride/src/features/auth/view_models/password_input.dart';
import 'package:dropsride/src/features/auth/view_models/text_input.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
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
                    AppSizes.padding,
                    AppSizes.padding * 2,
                    AppSizes.padding,
                    0,
                  ),
                  child: Column(
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
                      const Text('Please enter your details'),
                      hSizedBox8,

                      // form body with switching for sign up and login
                      Form(
                        key: aController.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                hSizedBox4,
                                EmailInputFields(
                                  controller: controller,
                                  name: "Email",
                                  aController: aController,
                                  inputType: TextInputType.emailAddress,
                                ),
                                hSizedBox4,
                                PasswordInputFields(
                                  name: "Password",
                                  controller: controller,
                                  aController: aController,
                                  inputType: TextInputType.text,
                                ),
                                hSizedBox4,
                                Obx(
                                  () => Row(children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: 1,
                                        color:
                                            aController.passwordScore.value >= 1
                                                ? AppColors.green
                                                : AppColors.grey,
                                        minHeight: AppSizes.p2,
                                      ),
                                    ),
                                    wSizedBox2,
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: 1,
                                        color:
                                            aController.passwordScore.value >= 2
                                                ? AppColors.green
                                                : AppColors.grey,
                                        minHeight: AppSizes.p2,
                                      ),
                                    ),
                                    wSizedBox2,
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: 1,
                                        color:
                                            aController.passwordScore.value >= 3
                                                ? AppColors.green
                                                : AppColors.grey,
                                        minHeight: AppSizes.p2,
                                      ),
                                    ),
                                    wSizedBox2,
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: 1,
                                        color:
                                            aController.passwordScore.value == 4
                                                ? AppColors.green
                                                : AppColors.grey,
                                        minHeight: AppSizes.p2,
                                      ),
                                    ),
                                  ]),
                                )
                              ],
                            )
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
