// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String? uid;
  final String state;
  final int amount;
  final int baseFarePercent;

  Location({
    String? state,
    int? amount,
    int? baseFarePercent,
    this.uid,
  })  : state = state ?? '',
        amount = amount ?? 1500,
        baseFarePercent = baseFarePercent ?? 500;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'state': state,
      'amount': amount,
      'baseFarePercent': baseFarePercent,
    };
  }

  factory Location.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Location(
      uid: document.id,
      state: data['state'] as String,
      amount: data['amount'] as int,
      baseFarePercent: data['baseFarePercent'] as int,
    );
  }
}
