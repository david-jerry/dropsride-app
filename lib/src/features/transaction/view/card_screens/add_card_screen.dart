import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Get.back(canPop: true, closeOverlays: false);
          },
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(pageTitle: "Add New Cards"),
      ),

      // body
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: SizedBox(
              child: Obx(
            () => Column(
              children: [
                CreditCardWidget(
                  cardBgColor: AppColors.cardDark,
                  backgroundImage: null,
                  isHolderNameVisible: true,
                  backgroundNetworkImage: null,
                  cardNumber: CardController.instance.creditCardNumber.value,
                  expiryDate: CardController.instance.creditCardExpDate.value,
                  cardHolderName: CardController.instance.creditCardName.value,
                  cvvCode: CardController.instance.creditCardCvv.value,
                  showBackView: CardController.instance.isCvvFocused.value,
                  padding: AppSizes.padding * 1.4,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {
                    CardController.instance.brandName.value =
                        creditCardBrand.brandName.toString();
                  },
                ),
                hSizedBox2,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding * 2),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onTap: () {
                            CardController.instance.isCvvFocused.value = false;
                          },
                          onChanged: (value) {
                            CardController.instance.creditCardNumber.value =
                                value.trim();

                            // if (value.startsWith('5061') ||
                            //     value.startsWith('5067')) {
                            //   CardController.instance.brandName.value = "Verve";
                            // }
                          },
                          inputFormatters: [
                            MaskedInputFormatter('0000 0000 0000 0000 000')
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: const Text('Card Number'),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            filled: true,
                            fillColor: AppColors.grey100.withOpacity(0.75),
                            isDense: true,
                            labelStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.grey400,
                                    ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.grey100,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                  width: 1, color: AppColors.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                  width: 1, color: AppColors.red),
                            ),
                          ),
                        ),
                        hSizedBox2,
                        TextFormField(
                          onTap: () {
                            CardController.instance.isCvvFocused.value = false;
                          },
                          onChanged: (value) {
                            CardController.instance.creditCardName.value =
                                value;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: const Text('Card Holder Name'),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            filled: true,
                            fillColor: AppColors.grey100.withOpacity(0.75),
                            isDense: true,
                            labelStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.grey400,
                                    ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.grey100,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                  width: 1, color: AppColors.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                              borderSide: const BorderSide(
                                  width: 1, color: AppColors.red),
                            ),
                          ),
                        ),
                        hSizedBox2,
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    CardController.instance.isCvvFocused.value =
                                        false;
                                  },
                                  validator: (value) {
                                    if (value != null) {
                                      if (value.trim().isEmpty) {
                                        return "Please enter and expiration date";
                                      }

                                      final parts = value.split('/');
                                      if (parts.length != 2) {
                                        return "Invalid date format. Please use MM/YY";
                                      }

                                      final month = int.tryParse(parts[0]);
                                      final year = int.tryParse(parts[1]);
                                      if (month == null ||
                                          month < 1 ||
                                          month > 12) {
                                        return "Invalid month. Please try again";
                                      }

                                      final currentYear =
                                          DateTime.now().year % 100;
                                      if (month < DateTime.now().month &&
                                          year != null &&
                                          year < currentYear) {
                                        return "You can not register an expired card";
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    CardController.instance.creditCardExpDate
                                        .value = value;
                                  },
                                  inputFormatters: [
                                    MaskedInputFormatter(
                                      '00/00',
                                    )
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: const Text('Exp. Date'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start,
                                    filled: true,
                                    fillColor:
                                        AppColors.grey100.withOpacity(0.75),
                                    isDense: true,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: AppColors.grey400,
                                        ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.grey100,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: AppColors.primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                          width: 1, color: AppColors.red),
                                    ),
                                  ),
                                ),
                              ),
                              wSizedBox2,
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    CardController.instance.isCvvFocused.value =
                                        true;
                                  },
                                  obscureText: true,
                                  onTapOutside: (event) {
                                    CardController.instance.isCvvFocused.value =
                                        false;
                                  },
                                  onChanged: (value) {
                                    CardController
                                        .instance.creditCardCvv.value = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: const Text('CVV'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start,
                                    filled: true,
                                    fillColor:
                                        AppColors.grey100.withOpacity(0.75),
                                    isDense: true,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: AppColors.grey400,
                                        ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.grey100,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: AppColors.primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.padding,
                                      ),
                                      borderSide: const BorderSide(
                                          width: 1, color: AppColors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // CreditCardForm(
                //   formKey: formKey,
                //   enableCvv: true,
                //   obscureCvv: true,
                //   obscureNumber: false,
                //   isHolderNameVisible: false,
                //   isCardNumberVisible: false,
                //   cardNumber: CardController.instance.creditCardNumber.value,
                //   expiryDate: CardController.instance.creditCardExpDate.value,
                //   cardHolderName: CardController.instance.creditCardName.value,
                //   cvvCode: CardController.instance.creditCardCvv.value,
                //   onCreditCardModelChange: (CreditCardModel model) {
                //     CardController.instance.creditCardExpDate.value =
                //         model.expiryDate;
                //     CardController.instance.creditCardCvv.value = model.cvvCode;
                //     CardController.instance.isCvvFocused.value =
                //         model.isCvvFocused;
                //   },
                //   expiryDateDecoration: InputDecoration(
                //     label: const Text('Exp. Date'),
                //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                //     floatingLabelAlignment: FloatingLabelAlignment.start,
                //     filled: true,
                //     fillColor: AppColors.grey100.withOpacity(0.75),
                //     isDense: true,
                //     labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //           color: AppColors.grey400,
                //         ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide: const BorderSide(
                //         width: 1,
                //         color: AppColors.grey100,
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide: const BorderSide(
                //           width: 1, color: AppColors.primaryColor),
                //     ),
                //     errorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide:
                //           const BorderSide(width: 1, color: AppColors.red),
                //     ),
                //   ),
                //   cvvCodeDecoration: InputDecoration(
                //     label: const Text('CVV'),
                //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                //     floatingLabelAlignment: FloatingLabelAlignment.start,
                //     filled: true,
                //     fillColor: AppColors.grey100.withOpacity(0.75),
                //     isDense: true,
                //     labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //           color: AppColors.grey400,
                //         ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide: const BorderSide(
                //         width: 1,
                //         color: AppColors.grey100,
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide: const BorderSide(
                //           width: 1, color: AppColors.primaryColor),
                //     ),
                //     errorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //         AppSizes.padding,
                //       ),
                //       borderSide:
                //           const BorderSide(width: 1, color: AppColors.red),
                //     ),
                //   ),
                //   themeColor: AppColors.primaryColor,
                // ),
                hSizedBox2,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.padding * 1.4),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        CardController.instance.submitCard(formKey);
                      },
                      child: Text(
                        CardController.instance.isLoading.value
                            ? 'Loading...'
                            : 'Submit',
                        style: const TextStyle(
                          fontSize: AppSizes.iconSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
