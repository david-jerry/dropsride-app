// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteDestination {
  final String? uid;
  final String? title;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime addedOn;

  FavouriteDestination({
    DateTime? addedOn,
    this.uid,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
  }) : addedOn = addedOn ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'addedOn': addedOn.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'addedOn': addedOn.millisecondsSinceEpoch,
    };
  }

  factory FavouriteDestination.fromMap(Map<String, dynamic> map) {
    return FavouriteDestination(
      title: map['title'] as String,
      address: map['address'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      addedOn: DateTime.fromMillisecondsSinceEpoch(map['addedOn'] as int),
    );
  }

  toJson() => json.encode(toMap());

  factory FavouriteDestination.fromJson(String source) =>
      FavouriteDestination.fromMap(json.decode(source) as Map<String, dynamic>);

  factory FavouriteDestination.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FavouriteDestination(
      uid: document.id,
      title: data['title'],
      address: data['address'],
      longitude: data['longitude'],
      latitude: data['latitude'],
      addedOn: DateTime.fromMillisecondsSinceEpoch(data['addedOn']),
    );
  }

  FavouriteDestination copyWith({
    String? uid,
    String? title,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? addedOn,
  }) {
    return FavouriteDestination(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addedOn: addedOn ?? this.addedOn,
    );
  }

  @override
  String toString() {
    return 'FavouriteDestination(uid: $uid, title: $title, address: $address, latitude: $latitude, longitude: $longitude, addedOn: $addedOn)';
  }
}
