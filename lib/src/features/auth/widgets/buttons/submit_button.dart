import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({
    super.key,
    required this.aController,
    required this.onPressed,
    required this.buttonText,
  });

  Future<void> Function() onPressed;
  String buttonText;
  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.infinity),
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.p12),
          ),
          elevation: AppSizes.p8,
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.buttonHeight / 2.9,
          ),
        ),
        onPressed: () {
          aController.isLoading.value ? null : onPressed();
        },
        child: aController.isLoading.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  wSizedBox6,
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: SizeConfig.screenHeight * 0.026,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  )
                ],
              )
            : Text(
                buttonText,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: SizeConfig.screenHeight * 0.026,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
      ),
    );
  }
}
