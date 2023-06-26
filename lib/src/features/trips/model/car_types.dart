import 'package:cloud_firestore/cloud_firestore.dart';

class CarType {
  String? uid;
  String name;
  int baseFare;
  int pricePerKm;
  int pricePerMinute;

  CarType({
    this.uid,
    String? name,
    int? baseFare,
    int? pricePerKm,
    int? pricePerMinute,
  })  : name = name ?? 'Unassigned',
        baseFare = baseFare ?? 0,
        pricePerKm = pricePerKm ?? 0,
        pricePerMinute = pricePerMinute ?? 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "baseFare": baseFare,
      "pricePerKm": pricePerKm,
      "pricePerMinute": pricePerMinute,
    };
  }

  factory CarType.fromMap(Map<String, dynamic> map) {
    return CarType(
      name: map['name'] != null ? map['name'] as String : 'Unassigned',
      baseFare: map['baseFare'] != null ? map['baseFare'] as int : 0,
      pricePerKm: map['pricePerKm'] != null ? map['pricePerKm'] as int : 0,
      pricePerMinute:
          map['pricePerMinute'] != null ? map['pricePerMinute'] as int : 0,
    );
  }

  factory CarType.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CarType(
      uid: document.id,
      name: data['name'] as String,
      baseFare: data['baseFare'] as int,
      pricePerKm: data['pricePerKm'] as int,
      pricePerMinute: data['pricePerMinute'] as int,
    );
  }
}
