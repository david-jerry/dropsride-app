import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/controller/repository/card_repository.dart';
import 'package:dropsride/src/features/transaction/view/card_screens/add_card_screen.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

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
        title: const AppBarTitle(pageTitle: "Cards"),
      ),

      // body
      body: Container(
        padding: const EdgeInsets.all(AppSizes.padding * 1.4),
        width: double.maxFinite,
        height: double.maxFinite,
        child: CardController.instance.debitCards.isNotEmpty
            ? Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: CardController.instance.debitCards.length,
                    itemBuilder: (context, index) {
                      final cardData =
                          CardController.instance.debitCards[index];
                      return Dismissible(
                        key: Key(cardData.uid!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: AppColors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.padding * 2.6),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) => CardRepository.instance
                            .deleteExistingCard(cardData.uid!),
                        child: InkWell(
                          onTap: () async {
                            CardController.instance.savePaymentType(
                                true,
                                cardData.authorizationCode,
                                cardData.creditCardNumber);
                          },
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: AppSizes.p6),
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.padding,
                              ),
                            ),
                            color: AppColors.cardDark,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(AppSizes.padding * 1.4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CARD NUMBER',
                                          style: TextStyle(
                                              color: AppColors.grey300,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          '${cardData.creditCardNumber.substring(0, 5)} xxxx xxxx xxxx',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1.8,
                                          ),
                                        ),
                                        hSizedBox2,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'month/year'.toUpperCase(),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.grey300,
                                                        fontSize: 10),
                                                  ),
                                                  Text(
                                                    cardData.creditCardExpDate,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      letterSpacing: 1.8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'cvv'.toUpperCase(),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.grey300,
                                                        fontSize: 10),
                                                  ),
                                                  const Text(
                                                    'xxx',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      letterSpacing: 1.8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        hSizedBox2,
                                        Text(
                                          'Name'.toUpperCase(),
                                          style: const TextStyle(
                                              color: AppColors.grey300,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          cardData.creditCardName.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1.8,
                                          ),
                                        ),
                                        hSizedBox2,
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => Radio(
                                      value: cardData.authorizationCode,
                                      groupValue: CardController.instance
                                          .selectedCardForPayment.value,
                                      onChanged: (value) {
                                        // if (value != null) {
                                        //   CardController
                                        //       .instance
                                        //       .selectedCardForPayment
                                        //       .value = value;
                                        // }
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  hSizedBox2,
                  CardController.instance.debitCards.length < 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.padding),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: InkWell(
                                  radius: AppSizes.p4,
                                  onTap: () {
                                    Get.to(() => const AddCardScreen());
                                  },
                                  child: Text(
                                    'Add Another Card +',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                              ),
                              hSizedBox2,
                            ],
                          ),
                        )
                      : hSizedBox2,
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(Assets.assetsImagesDriverImagesCardGroup),
                    hSizedBox2,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.padding),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              radius: AppSizes.p4,
                              onTap: () {
                                Get.to(() => const AddCardScreen());
                              },
                              child: Text(
                                'Add New Card +',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                          ),
                          hSizedBox2,
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
