import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/transaction/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionController.instance.startTimer();
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
          title: const AppBarTitle(pageTitle: "Manage Subscription"),
        ),

        // ! body
        body: Obx(
          () => SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding * 2.4),
              child: Column(
                children: [
                  Text(
                    'Period till next subscription',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  hSizedBox4,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Hours'),
                            hSizedBox2,
                            Text(
                              SubscriptionController.instance.hours.value
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                  ),
                            )
                          ],
                        ),
                      ),
                      wSizedBox2,
                      Column(
                        children: [
                          hSizedBox2,
                          Text(
                            ':',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                      wSizedBox2,
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Minutes'),
                            hSizedBox2,
                            Text(
                              SubscriptionController.instance.mins.value
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                  ),
                            )
                          ],
                        ),
                      ),
                      wSizedBox2,
                      Column(
                        children: [
                          hSizedBox2,
                          Text(
                            ':',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                      wSizedBox2,
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Seconds'),
                            hSizedBox2,
                            Text(
                              SubscriptionController.instance.seconds.value
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                  ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  hSizedBox4,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start/Stop Subscription',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'If turned on you will be charged a weekly fee of 20% of your total earnings for the week',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: AuthController
                            .instance.userModel.value!.isSubscribed,
                        onChanged: (value) async {
                          SubscriptionController.instance
                              .startPaymentAndTimer(value);
                        },
                      ),
                    ],
                  ),
                  hSizedBox8,
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Advantage',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.assetsImagesIconsDoubleGoodMark),
                      wSizedBox2,
                      Text(
                        'First to be considered for a drop',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.assetsImagesIconsDoubleGoodMark),
                      wSizedBox2,
                      Text(
                        'Benefit from mouth watering promos',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.assetsImagesIconsDoubleGoodMark),
                      wSizedBox2,
                      Text(
                        'Enjoy massive discount after a month',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
