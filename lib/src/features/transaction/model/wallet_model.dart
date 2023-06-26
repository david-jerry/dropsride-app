// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class WalletBal {
  final String? uid;
  final double balance;
  final DateTime? updatedAt;

  WalletBal({
    DateTime? updatedAt,
    double? balance,
    this.uid,
  })  : updatedAt = updatedAt ?? DateTime.now(),
        balance = balance ?? 0.00;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'balance': balance,
      'updatedAt': updatedAt!.millisecondsSinceEpoch,
    };
  }

  factory WalletBal.fromMap(Map<String, dynamic> map) {
    return WalletBal(
      uid: map['uid'] as String,
      balance: map['balance'] as double,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  factory WalletBal.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return WalletBal(
      uid: document.id,
      balance: data['balance'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
    );
  }
}
