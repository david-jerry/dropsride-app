// ignore_for_file: public_member_api_docs, sort_constructors_first

class Directions {
  String? address;
  String? locationName;
  String? locationID;
  double? locationLatitude;
  double? locationLongitude;
  Directions({
    this.address,
    this.locationName,
    this.locationID,
    this.locationLatitude,
    this.locationLongitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'locationName': locationName,
      'locationID': locationID,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
    };
  }

  factory Directions.fromMap(Map<String, dynamic> map) {
    return Directions(
      address: map['address'] != null ? map['address'] as String : null,
      locationName:
          map['locationName'] != null ? map['locationName'] as String : null,
      locationID:
          map['locationID'] != null ? map['locationID'] as String : null,
      locationLatitude: map['locationLatitude'] != null
          ? map['locationLatitude'] as double
          : null,
      locationLongitude: map['locationLongitude'] != null
          ? map['locationLongitude'] as double
          : null,
    );
  }
}
