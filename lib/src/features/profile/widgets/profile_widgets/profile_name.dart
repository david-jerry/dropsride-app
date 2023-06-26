import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class ProfileNameAndEmail extends StatelessWidget {
  const ProfileNameAndEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AuthController.find.userModel.value!.displayName ?? 'John Doe',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: AppSizes.p24,
              ),
        ),
        Text(
          AuthController.find.userModel.value!.phoneNumber != null
              ? "${AuthController.find.userModel.value!.phoneNumber?.countryCode} ${AuthController.find.userModel.value!.phoneNumber?.number}"
              : '+234 701 234 5678',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: AppSizes.p14,
              ),
        ),
      ],
    );
  }
}
