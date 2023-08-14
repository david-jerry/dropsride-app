import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/vehicle/model/vehicle_model.dart';
import 'package:get/get.dart';

class VehicleRepository extends GetxController {
  static VehicleRepository get instance => Get.find<VehicleRepository>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<VehicleModel> getDriverVehicle(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('vehicle_papers')
        .doc(uid)
        .get();

    if (!snapshot.exists) {
      return VehicleModel();
    }

    VehicleModel vehicleData = VehicleModel.fromSnapshot(snapshot);
    return vehicleData;
  }
}
