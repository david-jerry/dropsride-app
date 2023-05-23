import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtons extends StatelessWidget {
  CustomButtons({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.ontap,
  });

  IconData icon;
  String title;
  String description;
  void Function() ontap;

 final AuthController aController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aController.isLoading.value ? null : ontap,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.padding),
            color: Theme.of(context).colorScheme.onSurface),
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: AppSizes.iconSize * 3),
            wSizedBox4,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
