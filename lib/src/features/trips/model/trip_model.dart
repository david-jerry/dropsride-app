// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';

enum TripStatus {
  active,
  completed,
  cancelled,
}

class TripsHistoryModel {
  final String uid;
  final UserModel rider;
  final UserModel driver;
  final String carName;
  final String plateNumber;
  final Duration duration;
  final double distance;
  final double amount;
  final String pickup;
  final double pickUpLat;
  final double pickUpLon;
  final String dropOff;
  final double dropOffLat;
  final double dropOffLon;
  final UserRating rating;
  final TripStatus status;

  TripsHistoryModel({
    required this.uid,
    required this.rider,
    required this.driver,
    required this.carName,
    required this.plateNumber,
    required this.duration,
    required this.distance,
    required this.amount,
    required this.pickup,
    required this.pickUpLat,
    required this.pickUpLon,
    required this.dropOff,
    required this.dropOffLat,
    required this.dropOffLon,
    required this.rating,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'rider': rider.toMap(),
      'driver': driver.toMap(),
      'carName': carName,
      'plateNumber': plateNumber,
      'duration': duration.inMinutes,
      'distance': distance,
      'amount': amount,
      'pickup': pickup,
      'pickUpLat': pickUpLat,
      'pickUpLon': pickUpLon,
      'dropOff': dropOff,
      'dropOffLat': dropOffLat,
      'dropOffLon': dropOffLon,
      'rating': rating.toMap(),
      'status': status.name,
    };
  }

  factory TripsHistoryModel.fromMap(Map<String, dynamic> map) {
    return TripsHistoryModel(
      uid: map['uid'] as String,
      rider: UserModel.fromMap(map['rider'] as Map<String, dynamic>),
      driver: UserModel.fromMap(map['driver'] as Map<String, dynamic>),
      carName: map['carName'] as String,
      plateNumber: map['plateNumber'] as String,
      duration: map['duration'] as Duration,
      distance: map['distance'] as double,
      amount: map['amount'] as double,
      pickup: map['pickup'] as String,
      pickUpLat: map['pickUpLat'] as double,
      pickUpLon: map['pickUpLon'] as double,
      dropOff: map['dropOff'] as String,
      dropOffLat: map['dropOffLat'] as double,
      dropOffLon: map['dropOffLon'] as double,
      rating: UserRating.fromMap(map['rating'] as Map<String, dynamic>),
      status: map['status'] as TripStatus,
    );
  }

  factory TripsHistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TripsHistoryModel(
      uid: document.id,
      amount: data['amount'],
      rider: data['rider'],
      driver: data['driver'],
      carName: data['carName'],
      plateNumber: data['plateNumber'],
      duration: data['duration'],
      distance: data['distance'],
      pickup: data['pickup'],
      pickUpLat: data['pickUpLat'],
      pickUpLon: data['pickUpLon'],
      dropOff: data['dropOff'],
      dropOffLat: data['dropOffLat'],
      dropOffLon: data['dropOffLon'],
      rating: data['rating'],
      status: data['status'],
    );
  }

}
