import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FreeTripScreen extends StatelessWidget {
  const FreeTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Get.back(canPop: true, closeOverlays: false),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(
          pageTitle: 'Free Trips',
        ),
      ),

      // body
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Follow us on Social Media',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: AppSizes.iconSize,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            hSizedBox4,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.twitter,
                  color: Colors.blueAccent,
                  size: AppSizes.iconSize * 2,
                ),
                wSizedBox4,
                const Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                  size: AppSizes.iconSize * 2,
                ),
                wSizedBox4,
                const Icon(
                  FontAwesomeIcons.instagram,
                  color: Colors.deepPurple,
                  size: AppSizes.iconSize * 2,
                ),
              ],
            ),
            hSizedBox8,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSizes.padding),
                  elevation: 2,
                ),
                onPressed: () {},
                child: Text(
                  'Watch ads videos',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: AppSizes.iconSize * 1.2,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimary),
                ))
          ],
        ),
      ),
    );
  }
}
