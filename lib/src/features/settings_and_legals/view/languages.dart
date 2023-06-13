import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
          pageTitle: 'Languages',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding * 2.3),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Suggested',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                ),
              ),
              hSizedBox2,
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'English (US)',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      activeColor: AppColors.primaryColor,
                      value: 1,
                      groupValue: 1,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'English (UK)',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      activeColor: AppColors.primaryColor,
                      value: 2,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              hSizedBox2,
              const Divider(
                thickness: 3,
              ),
              hSizedBox2,
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Language',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                ),
              ),
              hSizedBox2,
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hindi',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 3,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Spanish',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 4,
                      groupValue: false,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'French',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 5,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bengali',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 6,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Russia',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 7,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Indonesia',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 8,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'German',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 9,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Italian',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                      ),
                    ),
                    Radio(
                      value: 10,
                      activeColor: AppColors.primaryColor,
                      groupValue: false,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
