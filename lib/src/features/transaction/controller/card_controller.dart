import 'package:dropsride/main.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/transaction/model/wallet_model.dart';
import 'package:dropsride/src/features/transaction/controller/repository/card_repository.dart';
import 'package:dropsride/src/features/transaction/model/card_model.dart';
import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CardController extends GetxController {
  RxBool cardPayment = false.obs;
  RxString selectedCardForPayment = ''.obs;

  RxString brandName = ''.obs;

  RxString creditCardCvv = ''.obs;
  RxString creditCardExpDate = ''.obs;
  RxString creditCardName = ''.obs;
  RxString creditCardNumber = ''.obs;
  RxBool isCvvFocused = false.obs;
  RxBool isLoading = false.obs;
  User? user = FirebaseAuth.instance.currentUser;

  static CardController get instance => Get.put(CardController());

  final _box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    selectedCardForPayment.value = _box.read('selectedCardForPayment') ?? '';
    cardPayment.value = _box.read('cardPayment') ?? false;
  }

  void savePaymentType(bool cardPaymentValue, String authorizationCode) async {
    await _box.write('cardPayment', cardPaymentValue);
    if (cardPaymentValue) {
      CardController.instance.cardPayment.value = cardPaymentValue;
      CardController.instance.selectedCardForPayment.value = authorizationCode;
      await _box.write('selectedCardForPayment', authorizationCode);
    } else {
      CardController.instance.cardPayment.value = cardPaymentValue;
      CardController.instance.selectedCardForPayment.value = authorizationCode;
      await _box.write('selectedCardForPayment', '');
    }
  }

  void submitCard(GlobalKey<FormState> formKey) async {
    PaystackPlugin paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: PAYSTACK_PK_API);

    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;

    formKey.currentState!.validate();

    if (creditCardNumber.value.isEmpty ||
        creditCardName.value.isEmpty ||
        creditCardCvv.value.isEmpty ||
        creditCardExpDate.value.isEmpty ||
        brandName.value.isEmpty) {
      showErrorMessage(
          "Form Error",
          "You are required to input all fields and ensure the card type icon shows to proceed",
          FontAwesomeIcons.creditCard);
      isLoading.value = false;
      return;
    }

    if (user == null) {
      showErrorMessage(
          "Authentication Error",
          "You must login to complete this submittion",
          FontAwesomeIcons.universalAccess);
      isLoading.value = false;
      return;
    }

    bool exists =
        await CardRepository.instance.cardExists(creditCardNumber.value);
    if (exists) {
      showWarningMessage(
          'Duplicate Error',
          'You already have a card with this exact number in the system, try adding another one!',
          FontAwesomeIcons.creditCard);
      isLoading.value = false;
      return;
    }

    PaymentCard card = PaymentCard(
      number: creditCardNumber.value.trim(),
      cvc: creditCardCvv.value.trim(),
      expiryMonth: int.parse(creditCardExpDate.split('/')[0]),
      expiryYear: int.tryParse(creditCardExpDate.split('/')[1]),
      name: creditCardName.value.trim(),
    );

    formKey.currentState!.save();
    formKey.currentState!.reset();

    // if (!card.isValid()) {
    //   showErrorMessage("Invalid Card", "Please add only valid cards",
    //       FontAwesomeIcons.creditCard);
    //   isLoading.value = false;
    //   return;
    // }

    Charge charge = Charge()
      ..amount = (50 * 100).toInt()
      ..reference = "DROPSCARD-${FirebaseAuth.instance.currentUser!.uid}"
      ..email = user!.email
      ..card = card;

    try {
      CheckoutResponse response;
      if (kDebugMode) {
        response = await paystackPlugin.checkout(Get.context!,
            charge: charge, hideEmail: true, method: CheckoutMethod.card);
      } else {
        response = await paystackPlugin.chargeCard(
          Get.context!,
          charge: charge,
        );
      }

      if (response.status == true) {
        if (kDebugMode) {
          print(response);
        }
        String authorizationCode = response.reference!;

        AuthController.instance.userBalance.value += 50.00;

        CardModel cardModel = CardModel(
          authorizationCode: authorizationCode,
          creditCardNumber: creditCardNumber.value,
          creditCardName: creditCardName.value,
          creditCardCvv: creditCardCvv.value,
          creditCardExpDate: creditCardExpDate.value,
          brandName: brandName.value,
        );

        TransactionHistory transactionHistory = TransactionHistory(
          category: TransactionCategory.card,
          paymentMethod: PaymentMethod.card,
          status: TransactionStatus.paid,
          type: TransactionType.deposit,
          amount: 50.00,
          referenceId: authorizationCode,
        );

        WalletBal walletBal = WalletBal(
          balance: AuthController.instance.userBalance.value,
        );

        await CardRepository.instance.submitCardToFirebase(
            user, cardModel, transactionHistory, walletBal);
      } else {
        showWarningMessage("Transaction Failed",
            "Payment failed: ${response.message}", FontAwesomeIcons.creditCard);
      }

      isLoading.value = false;
      return;
    } catch (e) {
      showErrorMessage(
        "Authorization Error",
        e.toString(),
        FontAwesomeIcons.creditCard,
      );
      return;
    }
  }
}
