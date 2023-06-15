import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  static TransactionController get instance => Get.put(TransactionController());

  User firebaseUser = FirebaseAuth.instance.currentUser!;
}
