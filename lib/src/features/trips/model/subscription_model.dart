// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropsride/src/features/profile/model/user_model.dart';
// import 'package:dropsride/src/features/trips/model/location_model.dart';

// class Subscription {
//   final String uid;
//   Location? locationId;
//   DateTime? expiresOn;
//   final bool isActive;

//   Subscription({
//     Location? locationId,
//     DateTime? expiresOn,
//     required this.uid,
//     required this.isActive,
//   });

//   Subscription copyWith({
//     String? uid,
//     Location? locationId,
//     DateTime? expiresOn,
//     bool? isActive,
//   }) {
//     return Subscription(
//       uid: uid ?? this.uid,
//       locationId: locationId ?? this.locationId,
//       expiresOn: expiresOn ?? this.expiresOn,
//       isActive: isActive ?? this.isActive,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'uid': uid,
//       'locationId': locationId?.toMap(),
//       'expiresOn': expiresOn?.millisecondsSinceEpoch,
//       'isActive': isActive,
//     };
//   }

//   factory Subscription.fromMap(Map<String, dynamic> map) {
//     return Subscription(
//       uid: map['uid'] as String,
//       locationId: map['locationId'] != null
//           ? Location.fromMap(map['locationId'] as Map<String, dynamic>)
//           : null,
//       expiresOn: map['expiresOn'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['expiresOn'] as int)
//           : null,
//       isActive: map['isActive'] as bool,
//     );
//   }

//   factory Subscription.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data()!;
//     return Subscription(
//       uid: document.id,
//       locationId: data['locationId'],
//       expiresOn: data['expiresOn'],
//       isActive: data['isActive'],
//     );
//   }

//   toJson() => json.encode(toMap());

//   factory Subscription.fromJson(String source) =>
//       Subscription.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Subscription(uid: $uid, locationId: $locationId, expiresOn: $expiresOn, isActive: $isActive)';
//   }

//   @override
//   bool operator ==(covariant Subscription other) {
//     if (identical(this, other)) return true;

//     return other.uid == uid &&
//         other.locationId == locationId &&
//         other.expiresOn == expiresOn &&
//         other.isActive == isActive;
//   }

//   @override
//   int get hashCode {
//     return uid.hashCode ^
//         locationId.hashCode ^
//         expiresOn.hashCode ^
//         isActive.hashCode;
//   }

//   static bool getDriverSubscriptionStatus(
//       List<Subscription> subscriptions, UserModel user) {
//     /// get user
//     for (Subscription subscription in subscriptions) {
//       if (subscription.uid == user.uid && user.isDriver && user.isVerified) {
//         return subscription.isActive;
//       }
//     }

//     return false;
//   }
// }
