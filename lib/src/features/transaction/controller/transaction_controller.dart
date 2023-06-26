import 'package:dropsride/src/features/transaction/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  static TransactionController get instance => Get.put(TransactionController());

  User firebaseUser = FirebaseAuth.instance.currentUser!;
  RxList<TransactionHistory> transactionHistory =
      RxList<TransactionHistory>([]);
}
