import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/deactivate_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DeactivateAccountScreen extends StatelessWidget {
  DeactivateAccountScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        title: const AppBarTitle(pageTitle: "Reason for Deactivation"),
      ),

      // !body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.padding * 2,
                vertical: AppSizes.padding,
              ),
              child: Text("Please select the reason for cancellation:"),
            ),
            hSizedBox2,
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding,
                    ),
                    child: Obx(
                      () => Column(
                        children: [
                          ListTile(
                            onTap: () => DeactivateController
                                        .instance.checkBoxChoice.value ==
                                    1
                                ? DeactivateController
                                    .instance.checkBoxChoice.value = 0
                                : DeactivateController
                                    .instance.checkBoxChoice.value = 1,
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10),
                            horizontalTitleGap: AppSizes.p0,
                            leading: Checkbox(
                                value: DeactivateController
                                        .instance.checkBoxChoice.value ==
                                    1,
                                onChanged: (value) {
                                  if (value == true) {
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 1;
                                    DeactivateController.instance.reason.value =
                                        "Trips too expensive";
                                  } else {
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 0;
                                  }
                                }),
                            title: Text(
                              "Trips too expensive",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                            ),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                          ),
                          ListTile(
                            dense: true,
                            onTap: () => DeactivateController
                                        .instance.checkBoxChoice.value ==
                                    2
                                ? DeactivateController
                                    .instance.checkBoxChoice.value = 0
                                : DeactivateController
                                    .instance.checkBoxChoice.value = 2,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10),
                            horizontalTitleGap: AppSizes.p0,
                            leading: Checkbox(
                                value: DeactivateController
                                            .instance.checkBoxChoice.value ==
                                        2
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  if (value == true) {
                                    DeactivateController.instance.reason.value =
                                        "Unable to use the app";
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 2;
                                  } else {
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 0;
                                  }
                                }),
                            title: Text(
                              "Unable to use the app",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                            ),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                          ),
                          ListTile(
                            onTap: () => DeactivateController
                                        .instance.checkBoxChoice.value ==
                                    3
                                ? DeactivateController
                                    .instance.checkBoxChoice.value = 0
                                : DeactivateController
                                    .instance.checkBoxChoice.value = 3,
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10),
                            horizontalTitleGap: AppSizes.p0,
                            leading: Checkbox(
                                value: DeactivateController
                                        .instance.checkBoxChoice.value ==
                                    3,
                                onChanged: (value) {
                                  if (value == true) {
                                    DeactivateController.instance.reason.value =
                                        "App is faulty";
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 3;
                                  } else {
                                    DeactivateController
                                        .instance.checkBoxChoice.value = 0;
                                  }
                                }),
                            title: Text(
                              "App is faulty",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                            ),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                          ),
                          hSizedBox2,
                          Padding(
                            padding: const EdgeInsets.all(AppSizes.padding),
                            child: TextFormField(
                              enabled: DeactivateController
                                          .instance.checkBoxChoice.value <
                                      1
                                  ? true
                                  : false,
                              enableIMEPersonalizedLearning: true,
                              validator: (value) {
                                if (value == null) {
                                  return "this field can not be null";
                                }

                                if (DeactivateController
                                            .instance.checkBoxChoice.value <
                                        1 &&
                                    value.trim().isEmpty) {
                                  return "this field can not be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                DeactivateController
                                    .instance.checkBoxChoice.value = 0;
                                DeactivateController.instance.reason.value =
                                    value;
                              },
                              // onTapOutside: (value) {
                              //   FocusScope.of(context).unfocus();
                              // },
                              decoration: InputDecoration(
                                label: const Text('Other Reasons'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.03),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                            ),
                          ),
                          hSizedBox4,
                          Padding(
                            padding: const EdgeInsets.all(AppSizes.padding),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  DeactivateController.instance
                                      .submitDeactivation(formKey, context);
                                },
                                child: DeactivateController
                                        .instance.deactivating.value
                                    ? const CircularProgressIndicator.adaptive()
                                    : Text(
                                        'Confirm Deactivation',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                            ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
