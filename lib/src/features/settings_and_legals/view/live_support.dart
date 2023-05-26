import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomerSupport extends StatelessWidget {
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: AppSizes.padding,
        leading: IconButton(
          onPressed: () => Get.back(canPop: true, closeOverlays: false),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(
          pageTitle: 'Customer Service',
        ),
        actions: [
          InkWell(
              onTap: () async {},
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: AppSizes.padding, horizontal: AppSizes.padding),
                child: Icon(Icons.add_comment_sharp),
              ))
        ],
      ),
      body: const Center(
        child: Text(
          'Customer Support',
        ),
      ),
    );
  }
}
