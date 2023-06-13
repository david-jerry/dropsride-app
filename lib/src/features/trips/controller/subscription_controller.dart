// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SubscriptionController extends GetxController {
//   static SubscriptionController get find => Get.find();

//   static SubscriptionController get instance =>
//       Get.put(SubscriptionController());

//   static const String _subscriptionKey = "subscription";
//   static const String _expiryTimestampKey = "expiryTimestamp";

//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   RxBool isActive = false.obs;
//   RxInt? expiryTimestamp;

//   @override
//   void onInit() {
//     super.onInit();
//     checkSubscriptionStatus();
//   }

//   Future<void> checkSubscriptionStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final subscription = prefs.getBool(_subscriptionKey);
//     final expiryTimestamp = prefs.getInt(_expiryTimestampKey);

//     if (subscription == true && expiryTimestamp != null) {
//       final currentTime = DateTime.now().millisecondsSinceEpoch;
//       if (currentTime < expiryTimestamp) {
//         isActive.value = true;
//         this.expiryTimestamp = expiryTimestamp.obs;
//         _startCountdownTimer(expiryTimestamp - currentTime);
//       }
//     }
//   }

//   Future<void> activateSubscription() async {
//     final prefs = await SharedPreferences.getInstance();
//     final currentTime = DateTime.now().millisecondsSinceEpoch;
//     final expiryTimestamp =
//         currentTime + const Duration(hours: 24).inMilliseconds;

//     await prefs.setBool(_subscriptionKey, true);
//     await prefs.setInt(_expiryTimestampKey, expiryTimestamp);

//     isActive.value = true;
//     this.expiryTimestamp = expiryTimestamp.obs;

//     _startCountdownTimer(expiryTimestamp - currentTime);
//   }

//   Future<void> deactivateSubscription() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_subscriptionKey, false);
//     await prefs.remove(_expiryTimestampKey);

//     isActive.value = false;
//     expiryTimestamp = null;

//     _stopCountdownTimer();
//   }

//   Timer? _countdownTimer;
//   void _startCountdownTimer(int countdownDuration) {
//     _countdownTimer = Timer(Duration(milliseconds: countdownDuration), () {
//       deactivateSubscription();
//     });
//   }

//   void _stopCountdownTimer() {
//     _countdownTimer?.cancel();
//     _countdownTimer = null;
//   }
// }
