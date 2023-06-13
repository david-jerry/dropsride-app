// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class POICategoryModel {
  final String title;
  final String description;
  POICategoryModel({
    required this.title,
    required this.description,
  });

  POICategoryModel copyWith({
    String? title,
    String? description,
  }) {
    return POICategoryModel(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  factory POICategoryModel.fromMap(Map<String, dynamic> map) {
    return POICategoryModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  factory POICategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return POICategoryModel(
      title: data['title'],
      description: data['description'],
    );
  }

  toJson() => json.encode(toMap());

  factory POICategoryModel.fromJson(String source) =>
      POICategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'POICategoryModel(title: $title, description: $description)';

  @override
  bool operator ==(covariant POICategoryModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}

// Point Of  interest model
class POIModel {
  final String uid;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final POICategoryModel category;
  POIModel({
    required this.uid,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.category,
  });

  POIModel copyWith({
    String? uid,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    POICategoryModel? category,
  }) {
    return POIModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      category: category ?? this.category,
    );
  }

  factory POIModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return POIModel(
      uid: document.id,
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      address: data['address'],
      category: data['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'category': category.toMap(),
    };
  }

  factory POIModel.fromMap(Map<String, dynamic> map) {
    return POIModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
      category:
          POICategoryModel.fromMap(map['category'] as Map<String, dynamic>),
    );
  }

  toJson() => json.encode(toMap());

  factory POIModel.fromJson(String source) =>
      POIModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'POIModel(uid: $uid, name: $name, latitude: $latitude, longitude: $longitude, address: $address, category: $category)';
  }

  @override
  bool operator ==(covariant POIModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.category == category;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode ^
        category.hashCode;
  }
}
