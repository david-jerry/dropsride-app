// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Bank {
  String? uid;
  String name;
  String accountNumber;
  String accountName;
  Bank({
    this.uid,
    required this.name,
    required this.accountNumber,
    required this.accountName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'accountNumber': accountNumber,
      'accountName': accountName,
    };
  }

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      name: map['name'] as String,
      accountNumber: map['accountNumber'] as String,
      accountName: map['accountName'] as String,
    );
  }

  factory Bank.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return Bank(
      uid: document.id,
      accountName: data['accountName'],
      accountNumber: data['accountNumber'],
      name: data['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bank.fromJson(String source) =>
      Bank.fromMap(json.decode(source) as Map<String, dynamic>);
}
