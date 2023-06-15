import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/transaction/controller/repository/transaction_repository.dart';
import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
        title: const AppBarTitle(pageTitle: "Transaction History"),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppSizes.padding * 1.4),
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<List<TransactionHistory>>(
          stream: TransactionRepository.instance.getUserTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'There was an error retrieving your transaction history.\n\n${snapshot.error.toString()}'),
              );
            } else {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                if (data.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final transaction = snapshot.data![index];
                      Widget? photo;
                      if (transaction.image != null) {
                        photo = Image.network(
                          transaction.image!,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                        );
                      } else {
                        if (transaction.payer!.contains('Subscription')) {
                          photo = SvgPicture.asset(
                            Assets.assetsImagesDriverIconTripHistoryClock,
                            color: AppColors.primaryColor,
                            width: AppSizes.iconSize * 2.4,
                            height: AppSizes.iconSize * 2.4,
                          );
                        } else {
                          photo = SvgPicture.asset(
                            Assets.assetsImagesDriverIconTransactionWallet,
                          );
                        }
                      }
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: AppSizes.p6),
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.padding,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.padding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: photo,
                              ),
                              wSizedBox4,
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        transaction.payer!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        DateFormat('MMM d, y | H:mm')
                                            .format(transaction.addedOn),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              wSizedBox2,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.assetsImagesIconsNairaIcon,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        height: 12,
                                      ),
                                      Text(
                                        "${transaction.amount}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        transaction.type.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey400,
                                        ),
                                      ),
                                      wSizedBox2,
                                      SvgPicture.asset(
                                        transaction.type.name ==
                                                TransactionType.deposit.name
                                            ? Assets.assetsImagesIconsDeposit
                                            : Assets.assetsImagesIconsWithdraw,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('There is no transaction to show right now'),
                  );
                }
              }
            }
            return const Center(
              child: Text('There is no transaction to show'),
            );
          },
        ),
      ),
    );
  }
}
