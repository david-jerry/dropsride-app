// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String? uid;
  final DateTime addedOn;
  final String authorizationCode;
  final String creditCardNumber;
  final String creditCardName;
  final String creditCardCvv;
  final String creditCardExpDate;
  final String brandName;

  CardModel({
    DateTime? addedOn,
    this.uid,
    required this.authorizationCode,
    required this.creditCardNumber,
    required this.creditCardName,
    required this.creditCardCvv,
    required this.creditCardExpDate,
    required this.brandName,
  }) : addedOn = addedOn ?? DateTime.now();

  factory CardModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return CardModel(
      uid: document.id,
      addedOn: DateTime.fromMillisecondsSinceEpoch(data['addedOn']),
      authorizationCode: data['authorizationCode'],
      creditCardNumber: data['creditCardNumber'],
      creditCardName: data['creditCardName'],
      creditCardCvv: data['creditCardCvv'],
      creditCardExpDate: data['creditCardExpDate'],
      brandName: data['brandName'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addedOn': addedOn.millisecondsSinceEpoch,
      'authorizationCode': authorizationCode,
      'creditCardNumber': creditCardNumber,
      'creditCardName': creditCardName,
      'creditCardCvv': creditCardCvv,
      'creditCardExpDate': creditCardExpDate,
      'brandName': brandName,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      addedOn: DateTime.fromMillisecondsSinceEpoch(map['addedOn'] as int),
      authorizationCode: map['authorizationCode'] as String,
      creditCardNumber: map['creditCardNumber'] as String,
      creditCardName: map['creditCardName'] as String,
      creditCardCvv: map['creditCardCvv'] as String,
      creditCardExpDate: map['creditCardExpDate'] as String,
      brandName: map['brandName'] as String,
    );
  }
}
