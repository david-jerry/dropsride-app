import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/settings_and_legals/view/contact_screen.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/view/card_screens/cards_screen.dart';
import 'package:dropsride/src/features/transaction/view/transactions_screen.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController.instance.getUserBalance();

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
        title: const AppBarTitle(pageTitle: "Payment"),
      ),

      // body
      body: Obx(
        () => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.padding * 1.4),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Card(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.padding)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.padding),
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: double.maxFinite,
                                  child: Text('Drops Balance'),
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    '₦ ${AuthController.instance.userBalance.value}',
                                    style: GoogleFonts.inter(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.secondaryColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      hSizedBox2,
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => const ContactScreen());
                              },
                              child: const Text(
                                'What is Drops Balance?',
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const TransactionScreen());
                              },
                              child: const Text(
                                'Transaction History',
                              ),
                            ),
                          ],
                        ),
                      ),
                      hSizedBox2,
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.2),
                  thickness: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.padding * 1.4),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Methods',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        hSizedBox2,
                        Obx(
                          () => InkWell(
                            onTap: () {
                              CardController.instance
                                  .savePaymentType(false, '');
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(Assets.assetsImagesIconsCash),
                                wSizedBox2,
                                const Expanded(child: Text('Cash')),
                                CardController.instance.cardPayment.value
                                    ? Radio(
                                        value: CardController
                                            .instance.cardPayment.value,
                                        groupValue: false,
                                        onChanged: (value) {})
                                    : SvgPicture.asset(
                                        Assets.assetsImagesIconsSelectedIcon,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const CardScreen());
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                Assets.assetsImagesIconsCardPng,
                              ),
                              wSizedBox2,
                              const Expanded(
                                  child: Text('Add Debit/Credit card')),
                              SvgPicture.asset(
                                Assets.assetsImagesIconsAngleRight,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            ],
                          ),
                        ),
                      ],
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
