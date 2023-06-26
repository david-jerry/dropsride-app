import 'dart:async';
import 'package:dropsride/main.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:dropsride/src/utils/alert.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController get instance =>
      Get.put(SubscriptionController());

  RxInt hours = 00.obs;
  RxInt mins = 00.obs;
  RxInt seconds = 00.obs;
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;
  final String _timerKey = 'countdown_timer';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() async {
    await Future.delayed(const Duration(milliseconds: 500));
    AssistantMethods.checkSubscriptionStatus();

    // Check if a timer is already running
    if (_timer != null) return;

    final int storedTime = GetStorage().read(_timerKey) ?? 0;

    // If there's a stored time, check if it's still valid
    if (AuthController.find.userModel.value!.isSubscribed && storedTime > 0) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      final int elapsedTime = currentTime - storedTime;
      if (elapsedTime < 24 * 60 * 60 * 1000) {
        final int remainingMilliseconds = (24 * 60 * 60 * 1000) - elapsedTime;
        startCountdown(remainingMilliseconds);
      }
    } else {
      // If no stored time or stored time is invalid, start from scratch
      // startCountdown(24 * 60 * 60 * 1000);
      clearTimer();
      resetTimerFields();
      return;
    }
  }

  void startCountdown(int duration) {
    final int endTime = DateTime.now().millisecondsSinceEpoch + duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      final int remainingMilliseconds = endTime - currentTime;

      if (remainingMilliseconds > 0) {
        final Duration remaining =
            Duration(milliseconds: remainingMilliseconds);
        formatDuration(remaining);
        update();
      } else {
        clearTimer();
        resetTimerFields();
        update();
      }
    });
  }

  void clearTimer() async {
    _timer?.cancel();
    GetStorage().write(_timerKey, 0);
    await AuthController.find
        .updateSubscriptionStatus(FirebaseAuth.instance.currentUser, false);
  }

  void resetTimerFields() {
    hours.value = 0;
    mins.value = 0;
    seconds.value = 0;
  }

  void formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    hours.value = int.parse(twoDigits(duration.inHours));
    mins.value = int.parse(twoDigits(duration.inMinutes.remainder(60)));
    seconds.value = int.parse(twoDigits(duration.inSeconds.remainder(60)));
  }

  void startPaymentAndTimer(bool value) async {
    if (value) {
      final bool paymentSuccessful = await _initiatePayment();
      if (paymentSuccessful) {
        final endTime = DateTime.now().millisecondsSinceEpoch +
            (24 * 60 * 60 * 1000) +
            (5 * 50 * 1000);
        AuthController.find.userModel.value!.isSubscribed = true;
        await GetStorage().write(_timerKey, endTime);
        startTimer();
        await AuthController.find
            .updateSubscriptionStatus(FirebaseAuth.instance.currentUser, true);

        // startBackgroundService(_timerKey);
      }
    } else {
      clearTimer();
      resetTimerFields();
    }
  }

  Future<bool> _initiatePayment() async {
    // Replace with your actual payment initiation logic using Paystack
    // Return true if payment initiation is successful, otherwise false
    PaystackPlugin paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: PAYSTACK_PK_API);

    Charge charge = Charge()
      ..amount = AuthController.find.userCurrentState.value!.amount *
          100 // The amount to charge in the smallest currency unit (e.g., kobo)
      ..email = FirebaseAuth.instance.currentUser!.email // Customer's email
      ..reference =
          "DROPSSUBSCRIPTION-${FirebaseAuth.instance.currentUser!.uid}-${DateTime.now().millisecondsSinceEpoch}"; // Unique reference

    CheckoutResponse response = await paystackPlugin.checkout(
      Get.context!,
      method: CheckoutMethod.card, // Payment method (e.g., card, bank)
      charge: charge,
    );

    if (response.status == true) {
      // Payment successful

      String authorizationCode = response.reference!;

      TransactionHistory transactionHistory = TransactionHistory(
        category: TransactionCategory.subscription,
        paymentMethod: PaymentMethod.card,
        status: TransactionStatus.paid,
        type: TransactionType.debit,
        amount: AuthController.find.userCurrentState.value!.amount.toDouble(),
        payer: "Daily Subscription",
        referenceId: authorizationCode,
      );
      // add transaction history also
      await _firestore
          .collection('transactions')
          .doc(user!.uid)
          .collection('history')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(transactionHistory.toMap())
          .catchError(
        (error, stackTrace) {
          showErrorMessage('Transaction Record Error', error.toString(),
              FontAwesomeIcons.history);
          return;
        },
      );

      AssistantMethods.getTransactions();
      return true; // Placeholder return value
    } else {
      // Payment failed
      return false; // Placeholder return value
    }
  }
}
