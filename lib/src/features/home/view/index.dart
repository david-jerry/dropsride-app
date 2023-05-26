import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/home/widget/sidebar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
      ),
      drawer: const SideBar(),
      body: const Center(
        child: Text(
          'Customer Support',
        ),
      ),
    );
  }
}
