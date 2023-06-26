import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/transaction/view/transactions_screen.dart';
import 'package:dropsride/src/features/transaction/view/subscription_screen.dart';
import 'package:dropsride/src/features/transaction/view/card_screens/cards_screen.dart';
import 'package:dropsride/src/utils/size_config.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
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
      ),
      body: SizedBox(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        child: Obx(
          () => Stack(
            children: [
              // ! background image
              Positioned(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(AppSizes.padding * 4),
                    ),
                  ),
                  child: Image.asset(
                    Assets.assetsImagesTripHistoryAppbarIllustration,
                    fit: BoxFit.cover,
                    height: SizeConfig.screenHeight * 0.3,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                height: SizeConfig.screenHeight * 0.3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.padding,
                    0,
                    AppSizes.padding,
                    AppSizes.padding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth * 0.15),
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.6,
                          child: Card(
                            color: AppColors.secondaryColor,
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding * 4,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.padding * 1.4,
                                  vertical: AppSizes.p8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Wallet Balance',
                                    style: TextStyle(
                                      color: AppColors.white100,
                                      fontSize: AppSizes.p10,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: AppColors.primaryColor,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppSizes.padding * 4,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes.p8,
                                            vertical: AppSizes.p2,
                                          ),
                                          child: Text(
                                            'NGN',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          AuthController.find.userModel.value!
                                              .totalEarnings!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 22,
                                                color: AppColors.white100,
                                                fontWeight: FontWeight.w900,
                                              ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      AppSizes.padding * 1.4,
                      SizeConfig.screenHeight * 0.18,
                      AppSizes.padding * 1.4,
                      0),
                  child: SizedBox(
                    width: SizeConfig.screenWidth - AppSizes.padding * 2.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSizes.padding),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  foregroundColor: AppColors.whiteColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.p16,
                                    vertical: AppSizes.p4,
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('Deposit'),
                              ),
                            ),
                            wSizedBox6,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(138),
                              child: Image.network(
                                AuthController
                                        .instance.userModel.value!.photoUrl ??
                                    kPlaceholder,
                                fit: BoxFit.cover,
                                height: 138,
                                width: 138,
                              ),
                            ),
                            wSizedBox6,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSizes.padding),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  foregroundColor: AppColors.whiteColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.p16,
                                    vertical: AppSizes.p4,
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('Withdraw'),
                              ),
                            ),
                          ],
                        ),
                        hSizedBox4,
                        InkWell(
                          onTap: () {
                            Get.to(() => const TransactionScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                  Assets.assetsImagesIconsTransactionHistory),
                              wSizedBox2,
                              Expanded(
                                child: Text(
                                  'Transaction History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.angleRight,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ],
                          ),
                        ),
                        hSizedBox2,
                        const Divider(thickness: 2),
                        hSizedBox2,
                        InkWell(
                          onTap: () {
                            Get.to(() => const SubscriptionScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                  Assets.assetsImagesIconsManageSubscription),
                              wSizedBox2,
                              Expanded(
                                child: Text(
                                  'Manage Subscription',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.angleRight,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ],
                          ),
                        ),
                        hSizedBox2,
                        const Divider(thickness: 2),
                        hSizedBox2,
                        InkWell(
                          onTap: () {
                            Get.to(() => const CardScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                  Assets.assetsImagesIconsPaymentMethod),
                              wSizedBox2,
                              Expanded(
                                child: Text(
                                  'Payment Methods',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.angleRight,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ],
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
    );
  }
}
