// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dropsride/src/features/profile/model/user_model.dart';

enum TripStatus {
  accepted,
  arrived,
  paused,
  started,
  active,
  waiting,
  ended,
  completed,
  cancelled,
}

class TripsHistoryModel {
  final String? uid;
  final String? riderId;
  final String? riderName;
  final double? riderRating;
  final String? riderPhone;
  final String? riderPhoto;
  final String? driverId;
  final String? driverName;
  final double? driverRating;
  final String? driverPhone;
  final String? driverPhoto;
  final String? carName;
  final String? carColor;
  final String? plateNumber;
  final int? duration;
  final double? distance;
  final double? longitude;
  final double? latitude;
  final double? amount;
  final String? pickup;
  final double? pickUpLat;
  final double? pickUpLon;
  final String? dropOff;
  final double? dropOffLat;
  final double? dropOffLon;
  final UserRating? rating;
  final TripStatus? status;

  TripsHistoryModel({
    TripStatus? status,
    this.uid,
    this.riderId,
    this.riderName,
    this.riderRating,
    this.riderPhone,
    this.riderPhoto,
    this.driverId,
    this.driverName,
    this.driverRating,
    this.driverPhone,
    this.driverPhoto,
    this.carName,
    this.carColor,
    this.plateNumber,
    this.duration,
    this.distance,
    this.amount,
    this.pickup,
    this.pickUpLat,
    this.pickUpLon,
    this.longitude,
    this.latitude,
    this.dropOff,
    this.dropOffLat,
    this.dropOffLon,
    this.rating,
  }) : status = status ?? TripStatus.waiting;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'riderId': riderId,
      'riderName': riderName,
      'riderRating': riderRating,
      'riderPhone': riderPhone,
      'riderPhoto': riderPhoto,
      'driverId': driverId,
      'driverName': driverName,
      'driverRating': driverRating,
      'driverPhone': driverPhone,
      'driverPhoto': driverPhoto,
      'carName': carName,
      'carColor': carColor,
      'plateNumber': plateNumber,
      'duration': duration as int,
      'distance': distance,
      'amount': amount,
      'pickup': pickup,
      'pickUpLat': pickUpLat,
      'pickUpLon': pickUpLon,
      'latitude': latitude,
      'longitude': longitude,
      'dropOff': dropOff,
      'dropOffLat': dropOffLat,
      'dropOffLon': dropOffLon,
      'rating': rating?.toMap(),
      'status': status?.name,
    };
  }

  Map<String, dynamic> toDriverMap() {
    return <String, dynamic>{
      'driverId': driverId,
      'driverName': driverName,
      'driverRating': driverRating,
      'driverPhone': driverPhone,
      'driverPhoto': driverPhoto,
      'latitude': latitude,
      'longitude': longitude,
      "carName": carName as String,
      "plateNumber": plateNumber as String,
      "status": status?.name,
      "carColor": carColor as String,
    };
  }

  factory TripsHistoryModel.fromMap(Map<String, dynamic> map) {
    return TripsHistoryModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      riderId: map['riderId'] as String,
      riderName: map['riderName'] != null ? map['riderName'] as String : null,
      riderRating:
          map['riderRating'] != null ? map['riderRating'] as double : null,
      riderPhone:
          map['riderPhone'] != null ? map['riderPhone'] as String : null,
      riderPhoto:
          map['riderPhoto'] != null ? map['riderPhoto'] as String : null,
      driverId: map['driverId'] as String,
      driverName:
          map['driverName'] != null ? map['driverName'] as String : null,
      driverRating:
          map['driverRating'] != null ? map['driverRating'] as double : null,
      driverPhone:
          map['driverPhone'] != null ? map['driverPhone'] as String : null,
      driverPhoto:
          map['driverPhoto'] != null ? map['driverPhoto'] as String : null,
      carName: map['carName'] != null ? map['carName'] as String : null,
      carColor: map['carColor'] != null ? map['carColor'] as String : null,
      plateNumber:
          map['plateNumber'] != null ? map['plateNumber'] as String : null,
      latitude: map["latitude"] as double,
      longitude: map["longitude"] as double,
      duration: map['duration'],
      distance: map['distance'] != null ? map['distance'] as double : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      pickup: map['pickup'] != null ? map['pickup'] as String : null,
      pickUpLat: map['pickUpLat'] != null ? map['pickUpLat'] as double : null,
      pickUpLon: map['pickUpLon'] != null ? map['pickUpLon'] as double : null,
      dropOff: map['dropOff'] != null ? map['dropOff'] as String : null,
      dropOffLat:
          map['dropOffLat'] != null ? map['dropOffLat'] as double : null,
      dropOffLon:
          map['dropOffLon'] != null ? map['dropOffLon'] as double : null,
      rating: map['rating'] != null
          ? UserRating.fromMap(map['rating'] as Map<String, dynamic>)
          : null,
      status: map['status'] as TripStatus,
    );
  }

  factory TripsHistoryModel.fromDriver(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TripsHistoryModel(
      driverId: data['driverId'],
      driverName: data['driverName'],
      driverRating: data['driverRating'],
      driverPhone: data['driverPhone'],
      driverPhoto: data['driverPhoto'],
      latitude: data["latitude"] as double,
      longitude: data["longitude"] as double,
    );
  }

  factory TripsHistoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TripsHistoryModel(
      uid: document.id,
      amount: data['amount'],
      riderId: data['riderId'],
      driverId: data['driverId'],
      riderName: data['riderName'],
      riderRating: data['riderRating'],
      riderPhone: data['riderPhone'],
      riderPhoto: data['riderPhoto'],
      driverName: data['driverName'],
      driverRating: data['driverRating'],
      driverPhone: data['driverPhone'],
      driverPhoto: data['driverPhoto'],
      carName: data['carName'],
      latitude: data["latitude"] as double,
      longitude: data["longitude"] as double,
      plateNumber: data['plateNumber'],
      carColor: data['carColor'],
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
