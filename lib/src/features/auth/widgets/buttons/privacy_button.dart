import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyButton extends StatelessWidget {
  const PrivacyButton({
    super.key,
    required this.aController,
  });

  final AuthController aController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.maxFinite,
        child: Row(
          children: [
            Checkbox(
                value: aController.check.value,
                mouseCursor: MouseCursor.uncontrolled,
                checkColor: AppColors.secondaryColor,
                activeColor: AppColors.primaryColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                onChanged: (value) => aController.check.value = value!),
            // ),
            InkWell(
              onTap: () => aController.check.value = !aController.check.value,
              child: Text(
                'I agree with ',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            InkWell(
              onTap: () => aController.goToTerm(),
              child: Text(
                'Terms ',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Text(
              'and ',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            InkWell(
              onTap: () => aController.goToTerm(),
              child: Text(
                'Privacy.',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
