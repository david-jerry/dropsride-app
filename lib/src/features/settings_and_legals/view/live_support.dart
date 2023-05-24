import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:flutter/material.dart';

class CustomerSupport extends StatelessWidget {
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: AppSizes.padding,
        elevation: 3,
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
