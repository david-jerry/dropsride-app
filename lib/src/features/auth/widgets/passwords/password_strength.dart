import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordStrength extends StatelessWidget {
  const PasswordStrength({
    super.key,
    required this.aController,
  });

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(children: [
        Expanded(
          child: LinearProgressIndicator(
            value: 1,
            color: aController.passwordScore.value >= 1
                ? AppColors.green
                : AppColors.grey,
            minHeight: AppSizes.p6,
          ),
        ),
        wSizedBox2,
        Expanded(
          child: LinearProgressIndicator(
            value: 1,
            color: aController.passwordScore.value >= 2
                ? AppColors.green
                : AppColors.grey,
            minHeight: AppSizes.p6,
          ),
        ),
        wSizedBox2,
        Expanded(
          child: LinearProgressIndicator(
            value: 1,
            color: aController.passwordScore.value >= 3
                ? AppColors.green
                : AppColors.grey,
            minHeight: AppSizes.p6,
          ),
        ),
        wSizedBox2,
        Expanded(
          child: LinearProgressIndicator(
            value: 1,
            color: aController.passwordScore.value == 4
                ? AppColors.green
                : AppColors.grey,
            minHeight: AppSizes.p6,
          ),
        ),
      ]),
    );
  }
}
