import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/bank_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/bank_repository.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountDetailsScreen extends StatelessWidget {
  AccountDetailsScreen({super.key});

  final repoController = Get.put(BankRepository());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
        title: const AppBarTitle(pageTitle: "Account Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding * 2),
          child: Form(
            key: formKey,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: const Text('Select Bank'),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSecondary,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.margin,
                        ),
                        borderSide: const BorderSide(
                            width: AppSizes.p2, color: AppColors.red),
                      ),
                    ),
                    value: BankController.instance.bankName.value.isEmpty
                        ? AuthController.find.bankList.first
                        : BankController.instance.bankName.value,
                    items: AuthController.find.bankList.map(
                      (e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: e.length < 33 ? Text(e) : Text("${e.substring(0, 33)}..."),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      BankController.instance.bankName.value = value!;
                    },
                    menuMaxHeight: double.maxFinite,
                    isDense: true,
                    hint: Text(
                      "Select Bank",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                  ),
                  hSizedBox2,
                  TextFormField(
                    enableIMEPersonalizedLearning: true,
                    validator: (value) {
                      if (value == null) {
                        return "this field can not be null";
                      }

                      return null;
                    },
                    initialValue:
                        BankController.instance.bankAccountNumber.value,
                    onChanged: (value) {
                      BankController.instance.bankAccountNumber.value = value;
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    // onTapOutside: (value) {
                    //   FocusScope.of(context).unfocus();
                    // },
                    decoration: InputDecoration(
                      label: const Text('Account Number'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
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
                            width: AppSizes.p2, color: AppColors.primaryColor),
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
                  hSizedBox2,
                  TextFormField(
                    enableIMEPersonalizedLearning: true,
                    validator: (value) {
                      if (value == null) {
                        return "this field can not be null";
                      }

                      return null;
                    },
                    initialValue: BankController.instance.bankAccountName.value,
                    onChanged: (value) {
                      BankController.instance.bankAccountName.value = value;
                    },
                    // onTapOutside: (value) {
                    //   FocusScope.of(context).unfocus();
                    // },
                    decoration: InputDecoration(
                      label: const Text('Account Name'),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
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
                            width: AppSizes.p2, color: AppColors.primaryColor),
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
                  hSizedBox2,
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        BankController.instance.submitBank(formKey);
                      },
                      child: BankController.instance.submitting.value
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
