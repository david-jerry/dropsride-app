import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:dropsride/src/features/trips/model/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LocationRepository extends GetxController {
  static LocationRepository get instance => Get.put(LocationRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser!;

  Future<Location> getCurrentUserLocationState(String state) async {
    final location = await _firestore
        .collection('states')
        .where('state', isEqualTo: state)
        .limit(1)
        .get();

    final locationData = location.docs.first;
    final locationDetails = Location.fromSnapshot(locationData);

    return locationDetails;
  }

  Future<List<CarType>> getCarTypes() async {
    final cartype = await _firestore
        .collection('car_categories')
        .where('name'.toLowerCase(), isNotEqualTo: 'Unassigned'.toLowerCase())
        .get();

    if (cartype.docs.isEmpty) {
      return <CarType>[];
    }

    final carTypeDetails =
        cartype.docs.map((e) => CarType.fromSnapshot(e)).toList();

    return carTypeDetails;
  }
}
