import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/widgets/passwords/forgot_password_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  ForgotPasswordButton({
    super.key,
    required this.aController,
  });
  AuthController aController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.p8),
      child: Center(
        child: InkWell(
          radius: AppSizes.p6,
          onTap: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.padding),
            ),
            builder: (context) {
              return ForgotPasswordBottomSheet(
                aController: aController,
              );
            },
          ),
          // aController.forgotPasswordToggle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "forgot password?",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
