import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/transaction/model/wallet_model.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/model/card_model.dart';
import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CardRepository extends GetxController {
  static CardRepository get instance => Get.put(CardRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser!;

  Future<void> submitCardToFirebase(User? user, CardModel cardModel,
      TransactionHistory transactionHistory, WalletBal walletBal) async {
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('cards')
        .doc("${user.uid}_${DateTime.now().millisecondsSinceEpoch}")
        .set(cardModel.toMap())
        .catchError(
      (error, stackTrace) {
        showErrorMessage('Card Registration Error', error.toString(),
            FontAwesomeIcons.creditCard);
        CardController.instance.isLoading.value = false;
        return;
      },
    );

    // add transaction history also
    await _firestore
        .collection('transactions')
        .doc(user.uid)
        .collection('history')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(transactionHistory.toMap())
        .catchError(
      (error, stackTrace) {
        showErrorMessage('Transaction Record Error', error.toString(),
            FontAwesomeIcons.history);
        CardController.instance.isLoading.value = false;
        return;
      },
    );

    // update user wallet balance
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallet')
        .doc(user.uid)
        .set(walletBal.toMap())
        .catchError(
      (error, stackTrace) {
        showErrorMessage(
            'Wallet Record Error', error.toString(), FontAwesomeIcons.history);
        CardController.instance.isLoading.value = false;
        return;
      },
    );

    AssistantMethods.readOnlineUserCurrentInfo();
  }

  Future<List<CardModel>> getUserCards() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('cards')
        .get();

    final cards = snapshot.docs.map((e) => CardModel.fromSnapshot(e)).toList();
    return cards;
  }

  Future<bool> cardExists(String number) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('cards')
        .where('creditCardNumber', isEqualTo: number)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteExistingCard(String uid) async {
    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('cards')
        .doc(uid)
        .delete();
  }

  Future<double> getUserBalance(User user) async {
    final wallet = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallet')
        .where(FieldPath.documentId, isEqualTo: user.uid)
        .get();

    final userWallet = wallet.docs
        .map(
          (e) => WalletBal.fromSnapshot(e),
        )
        .single;

    return userWallet.balance;
  }
}
