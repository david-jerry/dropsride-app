// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String uid;
  final String state;
  final double amount;

  Location({
    required this.uid,
    required this.state,
    required this.amount,
  });

  Location copyWith({
    String? uid,
    String? state,
    double? amount,
  }) {
    return Location(
      uid: uid ?? this.uid,
      state: state ?? this.state,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'state': state,
      'amount': amount,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      uid: map['uid'] as String,
      state: map['state'] as String,
      amount: map['amount'] as double,
    );
  }

  factory Location.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Location(
      uid: document.id,
      state: data['state'],
      amount: data['amount'],
    );
  }

  toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(uid: $uid, state: $state, amount: $amount)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.state == state && other.amount == amount;
  }

  @override
  int get hashCode => uid.hashCode ^ state.hashCode ^ amount.hashCode;
}
