import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/assistants/geofire_assistant.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/features/home/model/active_nearby_available_drivers.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:dropsride/src/features/trips/model/location_model.dart';
import 'package:dropsride/src/features/trips/model/trip_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationRepository extends GetxController {
  static LocationRepository get instance => Get.put(LocationRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  MapController map = Get.find<MapController>();
  final GetStorage _box = GetStorage();

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

  Future<void> saveTripRequest() async {
    print("Estimated DurationIn Minutes: ${map.estimatedArrivalTime.value}");
    map.bookingConfirmed.value = true;
    map.rideAccepted.value = true;
    map.bottomSheetHeight.value = 320;
    map.referenceRideRequest =
        FirebaseDatabase.instance.ref().child('trips').push();

    print("referenceRideRequest: ${map.referenceRideRequest}");

    final data = TripsHistoryModel(
      uid: map.referenceRideRequest!.key,
      amount: map.estimatedTripCost.value,
      carName: map.vehicleType.value!.name,
      distance: map.estimatedTripDistance.value,
      dropOff: map.userDropOffLocation.value!.locationName,
      dropOffLat: map.userDropOffLocation.value!.locationLatitude,
      dropOffLon: map.userDropOffLocation.value!.locationLongitude,
      duration: map.estimatedArrivalTime.value,
      pickup: map.userPickupLocation.value!.locationName,
      pickUpLat: map.userPickupLocation.value!.locationLatitude,
      pickUpLon: map.userPickupLocation.value!.locationLongitude,
      riderId: AuthController.find.userModel.value!.uid,
      riderName: AuthController.find.userModel.value!.displayName,
      riderRating:
          double.parse(AuthController.find.userModel.value!.totalEarnings!),
      riderPhone: AuthController.find.userModel.value!.phoneNumber!.number,
      riderPhoto: AuthController.find.userModel.value!.photoUrl,
      status: TripStatus.waiting,
      driverId: '',
      driverName: '',
      carColor: '',
      driverPhone: '',
      driverPhoto: '',
      driverRating: 0.0,
      plateNumber: '',
      longitude: 0.0,
      latitude: 0.0,
      rating: UserRating(),
    );

    _box.write('referenceRideRequest', map.referenceRideRequest!.key);

    print(
        "ref for ride request key stored in getStorage: ${_box.read('referenceRideRequest')}");

    await map.referenceRideRequest!.set(data.toMap());
    print("Submitted Ride Request to the database");

    map.tripRideRequestSnapshotInfo =
        map.referenceRideRequest!.onValue.listen((eventSnapshot) async {
      if (!eventSnapshot.snapshot.exists) {
        return;
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
              TripStatus.waiting.name &&
          map.bookingConfirmed.value) {
        final endBookingTime =
            DateTime.now().add(const Duration(seconds: 60 * 3));
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
          if (DateTime.now().millisecondsSinceEpoch <=
                  endBookingTime.millisecondsSinceEpoch ||
              !map.showSelectedDriver.value) {
            if ((eventSnapshot.snapshot.value as Map)['status'] ==
                    TripStatus.accepted.name &&
                (eventSnapshot.snapshot.value as Map)['latitude'] != 0.0 &&
                (eventSnapshot.snapshot.value as Map)['longitude'] != 0.0) {
              map.rideAccepted.value = true;
              map.showDriversMarker.value = false;
              map.driverArriving.value = true;
              timer.cancel();

              map.latitude.value =
                  (eventSnapshot.snapshot.value as Map)['latitude'] as double;
              map.longitude.value =
                  (eventSnapshot.snapshot.value as Map)['longitude'] as double;
              LatLng driverLatLng =
                  LatLng(map.latitude.value, map.longitude.value);

              await map.calculateDriverArriverTime(driverLatLng);
            } else {
              map.rideAccepted.value = false;
              map.showDriversMarker.value = true;
              map.driverArriving.value = false;
            }

            if (map.progressbarValue.value > 1) {
              map.progressbarValue.value = 0;
            }

            if (map.progressbarValue.value < 11) {
              map.progressbarValue.value += 0.1;
            }
          } else if (DateTime.now().millisecondsSinceEpoch >
              endBookingTime.millisecondsSinceEpoch) {
            map.referenceRideRequest!.remove();
            showInfoMessage(
                'NO DRIVER',
                'There is no active driver online at this moment',
                FontAwesomeIcons.carRear);
            map.cancelRideRequesting();
            timer.cancel();
          }
        });
      }

      if ((eventSnapshot.snapshot.value as Map)['driverName'] != null) {
        map.carColor.value =
            (eventSnapshot.snapshot.value as Map)['carColor'] as String;
        map.carName.value =
            (eventSnapshot.snapshot.value as Map)['carName'] as String;
        map.driverPhoto.value =
            (eventSnapshot.snapshot.value as Map)['carColor'] as String;
        map.driverRating.value =
            (eventSnapshot.snapshot.value as Map)['driverRating'] as double;
        map.name.value =
            (eventSnapshot.snapshot.value as Map)['driverName'] as String;
        map.phoneNumber.value =
            (eventSnapshot.snapshot.value as Map)['driverPhone'] as String;
        map.plateNumber.value =
            (eventSnapshot.snapshot.value as Map)['plateNumber'] as String;
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.arrived.name) {
        map.driverArrived.value = true;
        await map.getPolyPoints(
            map.userPickupLocation.value!, map.userDropOffLocation.value!);
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.started.name) {
        map.tripStarted.value = true;
        map.onTheTrip.value = true;
        // todo: send the rider a notification that their ride is here.
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.active.name) {
        map.onTheTrip.value = true;
        map.ridePaused.value = false;
        AssistantMethods.resumeLiveLocationUpdates();
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.paused.name) {
        map.ridePaused.value = true;
        map.onTheTrip.value = false;
        AssistantMethods.pauseLiveLocationUpdates();
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.ended.name) {
        map.tripHasEnded.value = true;
        map.tripRideRequestSnapshotInfo!.cancel();
        // todo: add a means to send the ride amount to the rider even when the driver shows them on their own app
        map.endRide();
        // todo: after ending the ride switch to a new screen showing the amount and then finalize the payment to complete the ride
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.completed.name) {
        // todo: save the new amount to the database as the final amount in cases
        // todo: where the trip still extends to a certain location
        map.onTheTrip.value = false;
        map.driverArrived.value = false;
        map.driverArriving.value = false;
        map.rideAccepted.value = false;
        map.showDriversMarker.value = true;
        // todo: once the ride has been completed find a means to switch to the
        // todo: home screen to start a new ride request.
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.cancelled.name) {
        map.rideCancelled.value = true;
        map.cancelRideRequesting();
      }
    });

    List<ActiveNearbyAvailableDrivers> activeOnlineDrivers =
        GeoFireAssistant.activeNearbyAvailableDriversList;

    // todo search available drivers who fall within the selected vehicle type
    searchBySelectedVehicleType(activeOnlineDrivers);
  }

  Future<void> searchBySelectedVehicleType(
      List<ActiveNearbyAvailableDrivers> activeOnlineDrivers) async {
    final carTypeName = map.vehicleType.value!.name;

    if (activeOnlineDrivers.length < 1) {
      showInfoMessage(
          "No Driver",
          "We currently do not have any available driver. Please try later.",
          FontAwesomeIcons.car);
      map.referenceRideRequest?.remove();
      map.cancelRideRequesting();
      return;
    }

    await getOnlineDriverList(
        activeOnlineDrivers); // retreiveOnlineDriversInformation

    print(map.activeOnlineNearbyDriverList.toString());

    for (int i = 0; i < map.activeOnlineNearbyDriverList.length; i++) {
      if (map.activeOnlineNearbyDriverList[i].carType!.name == carTypeName) {
        AssistantMethods.sendNotificationToDriverNow(
          map.activeOnlineNearbyDriverList[i].uid!,
          map.referenceRideRequest!.key!,
          Get.context,
        );
        map.showSelectedDriver.value = true;
        map.showSelectedDriverBottomSheetHeight.value = 300;
        FirebaseDatabase.instance
            .ref()
            .child('trips')
            .child(map.referenceRideRequest!.key!)
            .child('driverId')
            .onValue
            .listen((eventRideRequestSnapshot) async {
          print(eventRideRequestSnapshot.snapshot.value);

          if (eventRideRequestSnapshot.snapshot.value != null) {
            if (eventRideRequestSnapshot.snapshot.value != "waiting") {
              map.showAssignedDriver.value = true;
              map.showSelectedDriver.value = false;
              map.showSelectedDriverBottomSheetHeight.value = 300;
            }
          }
        });
      }
    }
  }

  Future<void> getOnlineDriverList(
      List<ActiveNearbyAvailableDrivers> onlineDrivers) async {
    map.activeOnlineNearbyDriverList.clear();

    for (int i = 0; i < onlineDrivers.length; i++) {
      var driverInfo = await UserRepository.instance
          .getUserDetails(onlineDrivers[i].driverId!);
      map.activeOnlineNearbyDriverList.add(driverInfo);

      print(map.activeOnlineNearbyDriverList.toString());
    }
  }

  Future<void> getActiveTrip() async {
    if (_box.read('referenceRideRequest') != null) {
      final databaseRefKey = _box.read('referenceRideRequest');
      map.referenceRideRequest =
          FirebaseDatabase.instance.ref().child('trips').child(databaseRefKey);
    } else {
      return;
    }

    map.tripRideRequestSnapshotInfo =
        map.referenceRideRequest!.onValue.listen((eventSnapshot) async {
      if (!eventSnapshot.snapshot.exists) {
        return;
      }

      map.bookingConfirmed.value = true;
      map.bottomSheetHeight.value = 230;

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
              TripStatus.waiting.name &&
          map.bookingConfirmed.value) {
        final endBookingTime =
            DateTime.now().add(const Duration(seconds: 60 * 3));
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
          if (!map.showSelectedDriver.value ||
              DateTime.now().millisecondsSinceEpoch <=
                  endBookingTime.millisecondsSinceEpoch) {
            if ((eventSnapshot.snapshot.value as Map)['status'] ==
                    TripStatus.accepted.name &&
                (eventSnapshot.snapshot.value as Map)['latitude'] != 0.0 &&
                (eventSnapshot.snapshot.value as Map)['longitude'] != 0.0) {
              map.rideAccepted.value = true;
              map.showDriversMarker.value = false;
              map.driverArriving.value = true;
              timer.cancel();

              map.latitude.value =
                  (eventSnapshot.snapshot.value as Map)['latitude'] as double;
              map.longitude.value =
                  (eventSnapshot.snapshot.value as Map)['longitude'] as double;
              LatLng driverLatLng =
                  LatLng(map.latitude.value, map.longitude.value);

              await map.calculateDriverArriverTime(driverLatLng);
            } else {
              map.rideAccepted.value = false;
              map.showDriversMarker.value = true;
              map.driverArriving.value = false;
            }

            if (map.progressbarValue.value > 1) {
              map.progressbarValue.value = 0;
            }

            if (map.progressbarValue.value < 11) {
              map.progressbarValue.value += 0.1;
            }
          } else if (DateTime.now().millisecondsSinceEpoch >
              endBookingTime.millisecondsSinceEpoch) {
            map.referenceRideRequest!.remove();
            showInfoMessage(
                'NO DRIVER',
                'There is no active driver online at this moment',
                FontAwesomeIcons.carRear);
            map.cancelRideRequesting();
            timer.cancel();
          }
        });
      }

      if ((eventSnapshot.snapshot.value as Map)['driverName'] != null) {
        map.carColor.value =
            (eventSnapshot.snapshot.value as Map)['carColor'] as String;
        map.carName.value =
            (eventSnapshot.snapshot.value as Map)['carName'] as String;
        map.driverPhoto.value =
            (eventSnapshot.snapshot.value as Map)['carColor'] as String;
        map.driverRating.value =
            (eventSnapshot.snapshot.value as Map)['driverRating'] * 1.0;
        map.name.value =
            (eventSnapshot.snapshot.value as Map)['driverName'] as String;
        map.phoneNumber.value =
            (eventSnapshot.snapshot.value as Map)['driverPhone'] as String;
        map.plateNumber.value =
            (eventSnapshot.snapshot.value as Map)['plateNumber'] as String;
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.arrived.name) {
        map.driverArrived.value = true;
        await map.getPolyPoints(
            map.userPickupLocation.value!, map.userDropOffLocation.value!);
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.started.name) {
        map.tripStarted.value = true;
        map.onTheTrip.value = true;
        // todo: send the rider a notification that their ride is here.
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.active.name) {
        map.onTheTrip.value = true;
        map.ridePaused.value = false;
        AssistantMethods.resumeLiveLocationUpdates();
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.paused.name) {
        map.ridePaused.value = true;
        map.onTheTrip.value = false;
        AssistantMethods.pauseLiveLocationUpdates();
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.ended.name) {
        map.tripHasEnded.value = true;
        map.tripRideRequestSnapshotInfo!.cancel();
        // todo: add a means to send the ride amount to the rider even when the driver shows them on their own app
        map.endRide();
        // todo: after ending the ride switch to a new screen showing the amount and then finalize the payment to complete the ride
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.completed.name) {
        // todo: save the new amount to the database as the final amount in cases
        // todo: where the trip still extends to a certain location
        map.onTheTrip.value = false;
        map.driverArrived.value = false;
        map.driverArriving.value = false;
        map.rideAccepted.value = false;
        map.showDriversMarker.value = true;
        // todo: once the ride has been completed find a means to switch to the
        // todo: home screen to start a new ride request.
      }

      if ((eventSnapshot.snapshot.value as Map)['status'] ==
          TripStatus.cancelled.name) {
        map.rideCancelled.value = true;
        map.cancelRideRequesting();
      }
    });
  }

  Future<dynamic> getCurrentTripDetail() async {
    if (_box.read('referenceRideRequest') != null) {
      final databaseKey = _box.read('referenceRideRequest');
      map.referenceRideRequest =
          FirebaseDatabase.instance.ref().child('trips').child(databaseKey);
    } else {
      return null;
    }

    final DatabaseEvent event = await map.referenceRideRequest!.once();
    final DataSnapshot snapshot = event.snapshot;
    final tripDetailData =
        TripsHistoryModel.fromMap(snapshot.value as Map<String, dynamic>);

    return tripDetailData;
  }

  Future<List<TripsHistoryModel>> getAllTrips() async {
    final DatabaseReference tripsRef =
        FirebaseDatabase.instance.ref().child('trips');

    final DatabaseEvent tripsEvent = await tripsRef
        .orderByChild('driver')
        .startAt('')
        .endAt('\uf8ff')
        .once();

    final DataSnapshot tripsSnapshot = tripsEvent.snapshot;

    final Map<dynamic, dynamic>? tripsData = tripsSnapshot.value as Map?;

    if (tripsData == null) {
      return <TripsHistoryModel>[];
    }

    final tripDetails = tripsData.entries
        .map((entry) => TripsHistoryModel.fromMap(entry.value))
        .toList();

    return tripDetails;
  }
}
