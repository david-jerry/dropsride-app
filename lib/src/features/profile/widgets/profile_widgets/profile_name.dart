import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';

class ProfileNameAndEmail extends StatelessWidget {
  const ProfileNameAndEmail({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          userData.displayName ?? 'John Doe',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground,
                fontSize: AppSizes.p24,
              ),
        ),
        Text(
          userData.phoneNumber!.number != null
              ? "${userData.phoneNumber?.countryCode} ${userData.phoneNumber?.number}"
              : '+234 701 234 5678',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(
                fontWeight: FontWeight.w300,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground,
                fontSize: AppSizes.p14,
              ),
        ),
      ],
    );
  }
}
