// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  final String? uid;
  final List<String>? imageUrls;
  final String? carModel;
  final String? carColor;
  final String? carPlateNumber;
  final bool? verified;
  final DateTime submittedOn;

  VehicleModel({
    DateTime? submittedOn,
    this.uid,
    this.carModel,
    this.carColor,
    this.carPlateNumber,
    this.imageUrls,
    this.verified = false,
  }) : submittedOn = submittedOn ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carModel': carModel,
      'carColor': carColor,
      'carPlateNumber': carPlateNumber,
      'imageUrls': imageUrls,
      'verified': verified,
      'submittedOn': submittedOn.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> updateToMap() {
    return <String, dynamic>{
      'carModel': carModel,
      'carColor': carColor,
      'carPlateNumber': carPlateNumber,
      'imageUrls': imageUrls,
      'verified': false,
      'submittedOn': submittedOn.millisecondsSinceEpoch,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      uid: map['uid'] as String,
      carModel: map['carModel'] as String,
      carColor: map['carColor'] as String,
      carPlateNumber: map['carPlateNumber'] as String,
      imageUrls: map['imageUrls'] as List<String>,
      verified: map['verified'] as bool,
      submittedOn:
          DateTime.fromMillisecondsSinceEpoch(map['submittedOn'] as int),
    );
  }

  factory VehicleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VehicleModel(
      uid: document.id,
      carModel: data['carModel'],
      carColor: data['carColor'],
      carPlateNumber: data['carPlateNumber'],
      imageUrls: data['imageUrls'],
      verified: data['verified'],
      submittedOn: data['submittedOn'],
    );
  }

  toJson() => json.encode(toMap());

  factory VehicleModel.fromJson(String source) =>
      VehicleModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
