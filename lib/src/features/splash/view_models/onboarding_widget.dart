import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:flutter/material.dart';

class OnBoardingPages extends StatelessWidget {
  OnBoardingPages({
    super.key,
    required this.image,
    required this.text,
  });

  String text;
  String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          hSizedBox10,
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.padding * 7.4),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          hSizedBox6,
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.padding * 4),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      // fontSize: SizeConfig.screenHeight * 0.026,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
