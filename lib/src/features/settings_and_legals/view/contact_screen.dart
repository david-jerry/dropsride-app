import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/settings_and_legals/view_models/faq.dart';
import 'package:dropsride/src/features/settings_and_legals/view_models/contact_list.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController? _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'help_center';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController!.index = tabIndex.value;
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: 1,
      vsync: this,
    );
    _tabController!.addListener(() {
      // when tab's controller value is updated make sure to update the tab index value, which is state restorable
      setState(() {
        tabIndex.value = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(
        child: SizedBox(
          width: SizeConfig.screenWidth / 3,
          child: const Text(
            'FAQs',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Tab(
        child: SizedBox(
          width: SizeConfig.screenWidth / 3,
          child: const Text(
            'Contact Us',
            textAlign: TextAlign.center,
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: AppSizes.padding,
        elevation: 0,
        title: const AppBarTitle(
          pageTitle: 'Help Center',
        ),
        bottom: TabBar(
          automaticIndicatorColorAdjustment: true,
          indicatorColor: AppColors.primaryColor,
          controller: _tabController,
          isScrollable: true,
          tabs: tabs,
        ),
      ),

      // body
      body: TabBarView(controller: _tabController, children: [
        FaqScreen(),
        const ContactUs(),
      ]),
    );
  }
}
