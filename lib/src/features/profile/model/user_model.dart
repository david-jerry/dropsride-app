import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum RideStatus {
  idle,
  active,
}

enum Gender {
  male,
  female,
  gender,
}

class PhoneNumberMap extends PhoneNumber {
  PhoneNumberMap({
    String? countryISOCode,
    String? countryCode,
    String? number,
  }) : super(
            countryCode: countryCode ?? '+234',
            countryISOCode: countryISOCode ?? 'NG',
            number: number ?? '7012345678');

  Map<String, dynamic> toMap() {
    return {
      'countryISOCode': countryISOCode,
      'countryCode': countryCode,
      'number': number,
    };
  }

  factory PhoneNumberMap.fromMap(Map<String, dynamic> map) {
    return PhoneNumberMap(
      countryISOCode:
          map['countryISOCode'] != null ? map['countryISOCode'] as String : '',
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : '',
      number: map['number'] != null ? map['number'] as String : '',
    );
  }
}

class UserRating {
  final String? uid;
  final double? rating;

  UserRating({
    double? rating,
    this.uid,
  }) : rating = rating ?? 5;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'rating': rating,
    };
  }

  factory UserRating.fromMap(Map<String, dynamic> map) {
    return UserRating(
      uid: map['uid'] as String,
      rating: map['rating'] as double,
    );
  }

  factory UserRating.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserRating(
      uid: document.id,
      rating: data['rating'] as double,
    );
  }
}

class DriverModel {
  String? name;
  String? phoneNumber;
  String? driverPhoto;
  double? driverRating;
  double? latitude;
  double? longitude;
  String? carName;
  String? carColor;
  String? plateNumber;

  DriverModel({
    this.name,
    this.phoneNumber,
    this.driverPhoto,
    this.driverRating,
    this.latitude,
    this.longitude,
    this.carName,
    this.carColor,
    this.plateNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'driverPhoto': driverPhoto,
      'driverRating': driverRating,
      'latitude': latitude,
      'longitude': longitude,
      'carName': carName,
      'carColor': carColor,
      'plateNumber': plateNumber,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      driverPhoto:
          map['driverPhoto'] != null ? map['driverPhoto'] as String : null,
      driverRating:
          map['driverRating'] != null ? map['driverRating'] as double : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      carName: map['carName'] != null ? map['carName'] as String : null,
      carColor: map['carColor'] != null ? map['carColor'] as String : null,
      plateNumber:
          map['plateNumber'] != null ? map['plateNumber'] as String : null,
    );
  }
}

class UserModel {
  String? uid;
  String? displayName;
  String? email;
  PhoneNumberMap? phoneNumber;
  CarType? carType;
  String? password;
  String? country;
  Gender? gender;
  String? photoUrl;
  String? totalEarnings;
  String? lastTripId;
  bool isVerified;
  bool phoneVerified;
  DateTime joinedOn;
  DateTime dateOfBirth;
  RideStatus rideStatus;
  bool isDriver;
  bool isOnline;
  bool isSubscribed;
  bool acceptTermsAndCondition;
  double? latitude;
  double? longitude;

  UserModel({
    DateTime? joinedOn,
    DateTime? dateOfBirth,
    Gender? gender,
    CarType? carType,
    this.latitude,
    this.longitude,
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.password,
    this.country,
    this.photoUrl,
    this.lastTripId,
    this.totalEarnings,
    this.isVerified = false,
    this.isDriver = false,
    this.isSubscribed = false,
    this.phoneVerified = false,
    this.rideStatus = RideStatus.idle,
    this.isOnline = false,
    this.acceptTermsAndCondition = true,
  })  : joinedOn = joinedOn ?? DateTime.now(),
        gender = gender ?? Gender.gender,
        dateOfBirth = dateOfBirth ??
            DateTime.now().subtract(
              const Duration(days: 365 * 18),
            ),
        carType = carType ??
            CarType(
                name: 'Unassigned',
                baseFare: 0,
                pricePerKm: 0,
                pricePerMinute: 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber?.toMap(),
      'password': password,
      'country': country,
      'gender': gender?.name,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
      'phoneVerified': phoneVerified,
      'carType': carType?.toMap(),
      'lastTripId': lastTripId,
      'totalEarnings': totalEarnings,
      'joinedOn': joinedOn.millisecondsSinceEpoch,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'isDriver': isDriver,
      'isOnline': isOnline,
      'longitude': longitude,
      'latitude': latitude,
      'rideStatus': rideStatus.name,
      'isSubscribed': isSubscribed,
      'acceptTermsAndCondition': acceptTermsAndCondition,
    };
  }

  Map<String, dynamic> updateDetailToMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'phoneNumber': phoneNumber?.toMap(),
      'country': country,
      'gender': gender?.name,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> updatePhotoToMap() {
    return <String, dynamic>{
      'photoUrl': photoUrl,
    };
  }

  Map<String, double> updateCoordinates() {
    return <String, double>{
      "longitude": longitude!,
      "latitude": latitude!,
    };
  }

  Map<String, bool> updatePhoneVerifiedStatus() {
    return <String, bool>{
      'phoneVerified': phoneVerified,
    };
  }

  Map<String, dynamic> updateEarnings() {
    return <String, dynamic>{
      'totalEarnings': totalEarnings,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber: map['phoneNumber'] != null
          ? PhoneNumberMap.fromMap(map['phoneNumber'] as Map<String, dynamic>)
          : null,
      carType: map['carType'] != null
          ? CarType.fromMap(map['carType'] as Map<String, dynamic>)
          : CarType(name: "Unassigned", pricePerKm: 0, pricePerMinute: 0),
      password: map['password'] != null ? map['password'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      country: map['country'] != null ? map['country'] as String : null,
      gender: map['gender'] != null ? map['gender'] as Gender : null,
      rideStatus: map['rideStatus'] != null
          ? map['rideStatus'] as RideStatus
          : RideStatus.idle,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      isVerified: map['isVerified'] as bool,
      lastTripId: map['lastTripId'],
      totalEarnings: map['totalEarnings'],
      phoneVerified: map['isVerified'] as bool,
      joinedOn: DateTime.fromMillisecondsSinceEpoch(map['joinedOn'] as int),
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      isDriver: map['isDriver'] as bool,
      isOnline: map['isOnline'] as bool,
      isSubscribed: map['isSubscribed'] as bool,
      acceptTermsAndCondition: map['acceptTermsAndCondition'] as bool,
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    Gender parseGender(String gender) {
      switch (gender) {
        case 'gender':
          return Gender.gender;
        case 'male':
          return Gender.male;
        case 'female':
          return Gender.female;
        default:
          return Gender.gender;
      }
    }

    RideStatus parseRideStatus(String status) {
      switch (status) {
        case 'active':
          return RideStatus.active;
        default:
          return RideStatus.idle;
      }
    }

    final genderToGender = parseGender(data['gender']);
    final statusToRideStatus = parseRideStatus(data['rideStatus']);

    return UserModel(
      uid: document.id,
      displayName: data['displayName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'] != null
          ? PhoneNumberMap.fromMap(data['phoneNumber'] as Map<String, dynamic>)
          : null,
      carType: data['carType'] != null
          ? CarType.fromMap(data['carType'] as Map<String, dynamic>)
          : null,
      password: data['password'],
      country: data['country'] != null ? data['country'] as String : '',
      gender: genderToGender,
      rideStatus: statusToRideStatus,
      photoUrl:
          data['photoUrl'] != null ? data['photoUrl'] as String : kPlaceholder,
      lastTripId: data['lastTripId'],
      totalEarnings: data['totalEarnings'],
      isVerified: data['isVerified'],
      phoneVerified: data['phoneVerified'],
      acceptTermsAndCondition: data['acceptTermsAndCondition'],
      joinedOn: DateTime.fromMillisecondsSinceEpoch(data['joinedOn']),
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth']),
      isDriver: data['isDriver'] as bool,
      longitude: data['longitude'],
      latitude: data['latitude'],
      isOnline: data['isOnline'] as bool,
      isSubscribed: data['isSubscribed'] ?? false,
    );
  }
}
