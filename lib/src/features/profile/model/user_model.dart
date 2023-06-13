import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class UserModel {
  final String? uid;
  final String? displayName;
  final String? email;
  final PhoneNumberMap? phoneNumber;
  final String? password;
  final String? country;
  final Gender? gender;
  final String? photoUrl;
  final bool isVerified;
  final DateTime joinedOn;
  final DateTime dateOfBirth;
  final bool isDriver;
  final bool isSubscribed;
  final bool acceptTermsAndCondition;

  UserModel({
    DateTime? joinedOn,
    DateTime? dateOfBirth,
    Gender? gender,
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.password,
    this.country,
    this.photoUrl,
    this.isVerified = false,
    this.isDriver = false,
    this.isSubscribed = false,
    this.acceptTermsAndCondition = true,
  })  : joinedOn = joinedOn ?? DateTime.now(),
        gender = gender ?? Gender.gender,
        dateOfBirth = dateOfBirth ??
            DateTime.now().subtract(
              const Duration(days: 365 * 18),
            );

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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber: map['phoneNumber'] != null
          ? PhoneNumberMap.fromMap(map['phoneNumber'] as Map<String, dynamic>)
          : null,
      password: map['password'] != null ? map['password'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      gender: map['gender'] != null ? map['gender'] as Gender : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      isVerified: map['isVerified'] as bool,
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
      phoneNumber:
          PhoneNumberMap.fromMap(data['phoneNumber'] as Map<String, dynamic>),
      password: data['password'],
      country: data['country'],
      gender: genderToGender,
      photoUrl: data['photoUrl'],
      isVerified: data['isVerified'],
      acceptTermsAndCondition: data['acceptTermsAndCondition'],
      joinedOn: DateTime.fromMillisecondsSinceEpoch(data['joinedOn']),
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth']),
      isDriver: data['isDriver'],
      isSubscribed: data['isSubscribed'] ?? false,
    );
  }
}

class UserRating {
  final String uid;
  final UserModel user;
  final double rating;

  UserRating({
    required this.uid,
    required this.user,
    required this.rating,
  });

  UserRating copyWith({
    String? uid,
    UserModel? user,
    double? rating,
  }) {
    return UserRating(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'user': user.toMap(),
      'rating': rating,
    };
  }

  factory UserRating.fromMap(Map<String, dynamic> map) {
    return UserRating(
      uid: map['uid'] as String,
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      rating: map['rating'] as double,
    );
  }

  factory UserRating.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserRating(
      uid: document.id,
      user: data['user'],
      rating: data['rating'],
    );
  }

  toJson() => json.encode(toMap());

  factory UserRating.fromJson(String source) =>
      UserRating.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserRating(uid: $uid, user: $user, rating: $rating)';

  @override
  bool operator ==(covariant UserRating other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.user == user && other.rating == rating;
  }

  @override
  int get hashCode => uid.hashCode ^ user.hashCode ^ rating.hashCode;

  static double getUserRating(List<UserRating> ratings, UserModel user) {
    List<UserRating> userRatings =
        ratings.where((element) => element.user.uid == user.uid).toList();

    if (userRatings.isEmpty) {
      return 0.00;
    }

    double sum = 0;
    for (double rating in userRatings.map((e) => e.rating)) {
      sum += rating;
    }

    return sum / userRatings.length;
  }
}
