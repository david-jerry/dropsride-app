import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class ToggleFormButton extends StatelessWidget {
  const ToggleFormButton({
    super.key,
    required this.aController,
  });

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        radius: AppSizes.p6,
        onTap: () => aController.toggleForm(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                aController.login.value
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              Text(
                aController.login.value ? "Sign Up" : "Login",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
        ),
      ),
    );
  }
}
