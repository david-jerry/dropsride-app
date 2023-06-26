import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:intl_phone_field/phone_number.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  bool isDriver;
  bool isSubscribed;
  bool acceptTermsAndCondition;

  UserModel({
    DateTime? joinedOn,
    DateTime? dateOfBirth,
    Gender? gender,
    CarType? carType,
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
      country: map['country'] != null ? map['country'] as String : null,
      gender: map['gender'] != null ? map['gender'] as Gender : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      isVerified: map['isVerified'] as bool,
      lastTripId: map['lastTripId'],
      totalEarnings: map['totalEarnings'],
      phoneVerified: map['isVerified'] as bool,
      joinedOn: DateTime.fromMillisecondsSinceEpoch(map['joinedOn'] as int),
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      isDriver: map['isDriver'] as bool,
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

    final genderToGender = parseGender(data['gender']);

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
      photoUrl:
          data['photoUrl'] != null ? data['photoUrl'] as String : kPlaceholder,
      lastTripId: data['lastTripId'],
      totalEarnings: data['totalEarnings'],
      isVerified: data['isVerified'],
      phoneVerified: data['phoneVerified'],
      acceptTermsAndCondition: data['acceptTermsAndCondition'],
      joinedOn: DateTime.fromMillisecondsSinceEpoch(data['joinedOn']),
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth']),
      isDriver: data['isDriver'],
      isSubscribed: data['isSubscribed'] ?? false,
    );
  }
}
