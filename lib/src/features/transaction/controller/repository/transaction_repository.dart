import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TransactionRepository extends GetxController {
  static TransactionRepository get instance => Get.put(TransactionRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser!;

  Stream<List<TransactionHistory>> getUserTransactions() {
    final snapshot = _firestore
        .collection('transactions')
        .doc(firebaseUser.uid)
        .collection('history')
        .snapshots();

    final userData = snapshot.map((e) => e.docs
        .where((element) => element.id.isNotEmpty)
        .map((e) => TransactionHistory.fromSnapshot(e))
        .toList());
    return userData;
  }

  Future<List<TransactionHistory>> getAllTransactions(String uid) async {
    final snapshot = await _firestore
        .collection('transactions')
        .doc(uid)
        .collection('history')
        .where('status', isNull: false)
        .get();

    if (snapshot.docs.isEmpty) {
      return <TransactionHistory>[];
    }

    final transactions = snapshot.docs
        .map(
          (e) => TransactionHistory.fromSnapshot(e),
        )
        .toList();
    return transactions;
  }
}
