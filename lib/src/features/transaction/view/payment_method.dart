import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const AppBarTitle(pageTitle: "Payment Methods"),
      ),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.all(AppSizes.padding * 1.4),
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  child: Text('Select your preferred payment method'),
                ),
                hSizedBox6,
                InkWell(
                  onTap: () {
                    if (double.parse(AuthController
                            .instance.userModel.value!.totalEarnings!) >
                        500) {
                      CardController.instance.paymentMethod.value = 'wallet';
                    } else {
                      showWarningMessage(
                          'Insufficient Balance',
                          'You do not have up to the required amount on your wallet!',
                          FontAwesomeIcons.moneyBill);
                    }
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.padding * 1.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.padding),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.assetsImagesIconsWallet,
                            color: AppColors.primaryColor,
                            width: AppSizes.iconSize * 1.4,
                          ),
                          wSizedBox2,
                          Expanded(
                            child: Text(
                              "My Wallet",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                          Text(
                            '₦ ${AuthController.find.userModel.value!.totalEarnings}',
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondaryColor,
                                  ),
                            ),
                          ),
                          wSizedBox2,
                          Radio(
                            value: 'wallet',
                            groupValue:
                                CardController.instance.paymentMethod.value,
                            onChanged: (value) {
                              if (double.parse(AuthController
                                      .find.userModel.value!.totalEarnings!) >
                                  500) {
                                CardController.instance.paymentMethod.value =
                                    value.toString();
                              } else {
                                showWarningMessage(
                                    'Insufficient Balance',
                                    'You do not have up to the required amount on your wallet!',
                                    FontAwesomeIcons.moneyBill);
                              }
                            },
                            activeColor: AppColors.primaryColor,
                            overlayColor: const MaterialStatePropertyAll(
                                AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                hSizedBox2,
                if (CardController.instance.selectedCardNumber.value.isNotEmpty)
                  InkWell(
                    onTap: () {
                      CardController.instance.paymentMethod.value = 'card';
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.padding * 1.4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.padding),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.assetsImagesIconsMastercard,
                                width: AppSizes.iconSize * 1.4),
                            wSizedBox2,
                            Expanded(
                              child: Text(
                                "${CardController.instance.selectedCardNumber.value.substring(0, 5)} **** **** ****",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            Obx(
                              () => Radio(
                                value: 'card',
                                groupValue:
                                    CardController.instance.paymentMethod.value,
                                onChanged: (value) {
                                  CardController.instance.paymentMethod.value =
                                      value.toString();
                                },
                                activeColor: AppColors.primaryColor,
                                overlayColor: const MaterialStatePropertyAll(
                                    AppColors.primaryColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (CardController.instance.selectedCardNumber.value.isNotEmpty)
                  hSizedBox2,
                InkWell(
                  onTap: () {
                    CardController.instance.paymentMethod.value = 'cash';
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.padding * 1.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.padding),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.assetsImagesIconsCash,
                            color: AppColors.green,
                            width: AppSizes.iconSize * 1.4,
                          ),
                          wSizedBox2,
                          Expanded(
                            child: Text(
                              "Cash",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                          Obx(
                            () => Radio(
                              value: 'cash',
                              groupValue:
                                  CardController.instance.paymentMethod.value,
                              onChanged: (value) {
                                CardController.instance.paymentMethod.value =
                                    value.toString();
                              },
                              activeColor: AppColors.primaryColor,
                              overlayColor: const MaterialStatePropertyAll(
                                  AppColors.primaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
