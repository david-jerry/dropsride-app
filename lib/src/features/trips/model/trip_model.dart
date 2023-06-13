// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';

enum TripStatus {
  active,
  completed,
  cancelled,
}

class Trips {
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

  Trips({
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

  factory Trips.fromMap(Map<String, dynamic> map) {
    return Trips(
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

  factory Trips.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Trips(
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

  toJson() => json.encode(toMap());

  factory Trips.fromJson(String source) =>
      Trips.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Trips(uid: $uid, rider: $rider, driver: $driver, carName: $carName, plateNumber: $plateNumber, duration: $duration, distance: $distance, amount: $amount, pickup: $pickup, pickUpLat: $pickUpLat, pickUpLon: $pickUpLon, dropOff: $dropOff, dropOffLat: $dropOffLat, dropOffLon: $dropOffLon, rating: $rating, status: $status)';
  }

  Trips copyWith({
    String? uid,
    UserModel? rider,
    UserModel? driver,
    String? carName,
    String? plateNumber,
    Duration? duration,
    double? distance,
    double? amount,
    String? pickup,
    double? pickUpLat,
    double? pickUpLon,
    String? dropOff,
    double? dropOffLat,
    double? dropOffLon,
    UserRating? rating,
    TripStatus? status,
  }) {
    return Trips(
      uid: uid ?? this.uid,
      rider: rider ?? this.rider,
      driver: driver ?? this.driver,
      carName: carName ?? this.carName,
      plateNumber: plateNumber ?? this.plateNumber,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      amount: amount ?? this.amount,
      pickup: pickup ?? this.pickup,
      pickUpLat: pickUpLat ?? this.pickUpLat,
      pickUpLon: pickUpLon ?? this.pickUpLon,
      dropOff: dropOff ?? this.dropOff,
      dropOffLat: dropOffLat ?? this.dropOffLat,
      dropOffLon: dropOffLon ?? this.dropOffLon,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(covariant Trips other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.rider == rider &&
        other.driver == driver &&
        other.carName == carName &&
        other.plateNumber == plateNumber &&
        other.duration == duration &&
        other.distance == distance &&
        other.amount == amount &&
        other.pickup == pickup &&
        other.pickUpLat == pickUpLat &&
        other.pickUpLon == pickUpLon &&
        other.dropOff == dropOff &&
        other.dropOffLat == dropOffLat &&
        other.dropOffLon == dropOffLon &&
        other.rating == rating &&
        other.status == status;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        rider.hashCode ^
        driver.hashCode ^
        carName.hashCode ^
        plateNumber.hashCode ^
        duration.hashCode ^
        distance.hashCode ^
        amount.hashCode ^
        pickup.hashCode ^
        pickUpLat.hashCode ^
        pickUpLon.hashCode ^
        dropOff.hashCode ^
        dropOffLat.hashCode ^
        dropOffLon.hashCode ^
        rating.hashCode ^
        status.hashCode;
  }
}
