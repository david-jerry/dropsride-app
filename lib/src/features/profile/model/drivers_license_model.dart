// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class DriverLicenseModel {
  final String? uid;
  final String holder;
  final String license;
  final bool verified;
  final DateTime addedOn;
  DriverLicenseModel({
    DateTime? addedOn,
    this.uid,
    required this.holder,
    required this.license,
    this.verified = false,
  }) : addedOn = addedOn ?? DateTime.now();


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'holder': holder,
      'license': license,
      'verified': verified,
      'addedOn': addedOn.millisecondsSinceEpoch,
    };
  }

  factory DriverLicenseModel.fromMap(Map<String, dynamic> map) {
    return DriverLicenseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      holder: map['holder'] as String,
      license: map['license'] as String,
      verified: map['verified'] as bool,
      addedOn: DateTime.fromMillisecondsSinceEpoch(map['addedOn'] as int),
    );
  }

    factory DriverLicenseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return DriverLicenseModel(
      uid: document.id,
      holder: data['holder'],
      license: data['license'],
      addedOn: DateTime.fromMillisecondsSinceEpoch(data['addedOn']),
      verified: data['verified'],
    );
  }

}
