// General suggestion: make sure to import the necessary packages for this code block

import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/settings_and_legals/model/faq_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({
    super.key,
  });

  // ignore: prefer_final_fields
  RxString _selectedTag = 'General'.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding * 2),
      width: double.maxFinite,
      height: double.infinity,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(vertical: AppSizes.padding * 1.4),
              child: Row(
                children: tags.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectedTag.value = tag;
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.padding * 2.3,
                              vertical: AppSizes.padding),
                          backgroundColor: _selectedTag.value == tag
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _selectedTag.value == tag
                                    ? Colors.transparent
                                    : AppColors.primaryColor,
                                width: 3,
                              )),
                          foregroundColor:
                              Theme.of(context).colorScheme.background),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: AppSizes.p18,
                              color: _selectedTag.value == tag
                                  ? AppColors.secondaryColor
                                  : AppColors.primaryColor,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            hSizedBox2,
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  final faq = faqList[index];
                  final question = faq['question'];
                  final answer = faq['answer'];
                  final tag = faq['tag'];

                  if (_selectedTag.value == 'General' ||
                      tag!.contains(_selectedTag.value)) {
                    return Card(
                      color: Get.isDarkMode
                          ? AppColors.grey200.withOpacity(0.2)
                          : AppColors.grey100,
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: AppSizes.p4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.padding),
                      ),
                      child: ExpansionTile(
                        title: Text(question!),
                        children: [
                          Divider(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(answer!),
                          ),
                          hSizedBox2,
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
