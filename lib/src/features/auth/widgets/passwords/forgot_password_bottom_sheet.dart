import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/view/forget_password_screen.dart';
import 'package:dropsride/src/features/auth/widgets/buttons/otp_email_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  ForgotPasswordBottomSheet({
    super.key,
    required this.aController,
  });

  AuthController aController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hSizedBox4,
            Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            hSizedBox2,
            Text(
              'Please select an option below to reset your password automatically.',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    letterSpacing: 1,
                  ),
            ),
            Divider(
              height: AppSizes.p18 * 2.8,
              color: Theme.of(context).colorScheme.onBackground,
            ),

            // email button
            CustomButtons(
                ontap: () {
                  AuthController.instance.forgotPasswordEmail.value = true;
                  Get.to(() => ForgetPasswordScreen());
                },
                icon: Icons.email_rounded,
                title: "Email",
                description: "Reset via email verification"),
            hSizedBox4,

            // otp button
            CustomButtons(
                ontap: () {
                  AuthController.instance.forgotPasswordEmail.value = false;
                  Get.to(() => ForgetPasswordScreen());
                },
                icon: Icons.mobile_friendly_rounded,
                title: "Phone No",
                description: "Reset via phone verification"),
          ],
        ),
      ),
    );
  }
}
