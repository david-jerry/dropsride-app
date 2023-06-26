// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/request_assistant.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/model/direction_details_info_model.dart';
import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:dropsride/src/features/profile/controller/repository/bank_repository.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/transaction/controller/card_controller.dart';
import 'package:dropsride/src/features/transaction/controller/repository/card_repository.dart';
import 'package:dropsride/src/features/transaction/controller/repository/transaction_repository.dart';
import 'package:dropsride/src/features/transaction/controller/subscription_controller.dart';
import 'package:dropsride/src/features/transaction/controller/transaction_controller.dart';
import 'package:dropsride/src/features/trips/controller/repository/location_repository.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:dropsride/src/features/trips/model/trip_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../features/home/controller/map_controller.dart';

final String GOOGLE_API_KEY = dotenv.env['MAP_API_KEY']!;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User? user;
UserModel? userModel;

// ? saved shared preferences
final _box = GetStorage();
const String _timerKey = 'countdown_timer';

AuthController auth = Get.find<AuthController>();

class AssistantMethods {
  // ?INFO: get geoCoded address
  static Future<String> searchAddressForGeoCoordinates(
      Position position, context) async {
    String address = '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLE_API_KEY');

    final addressResponse = await http.get(url);

    if (json.decode(addressResponse.body)['results'].length > 0) {
      address = json
          .decode(addressResponse.body)['results'][0]['formatted_address']
          .toString();

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = address;
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;

      MapController.find.updatePickupLocationAddress(userPickupAddress);
    }
    return address;
  }

  static Future<String> searchDropoffAddressForGeoCoordinates(
      Position position, context) async {
    String address = '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLE_API_KEY');

    final addressResponse = await http.get(url);

    if (json.decode(addressResponse.body)['results'].length > 0) {
      address = json
          .decode(addressResponse.body)['results'][0]['formatted_address']
          .toString();

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = address;
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;

      MapController.find.updateDropoffLocationAddress(userPickupAddress);
    }
    return address;
  }

  static Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 40);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static void readOnlineUserCurrentInfo() async {
    user = auth.user.value = firebaseAuth.currentUser;
    userModel = auth.userModel.value =
        await UserRepository.instance.getCurrentUser(user!.uid);

    _box.write('userPhotoUrl', userModel!.photoUrl);

    // ? get users details
    readRatingInfo();
    getTransactions();
    checkSubscriptionStatus();
    getUserBalance();
    getUserCards();
    getUserBankList();
    getUserBankDetails();
    getCarTypes();
  }

  static void checkUserExist(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      FirebaseAuth.instance.signOut();
      return;
    }
  }

  static void getUserBankList() async {
    auth.bankList.value = await BankRepository.instance.fetchNigerianBanks();
  }

  static void getUserBankDetails() async {
    auth.userBank.value = await BankRepository.instance.userBankDetails();
  }

  static void getCarTypes() async {
    MapController.find.carTypes.value =
        await LocationRepository.instance.getCarTypes();
  }

  static void getUserBalance() async {
    double balance = await CardRepository.instance.getUserBalance(user!);

    auth.userModel.value!.totalEarnings = balance.toStringAsFixed(2);

    try {
      await firestore
          .collection('users')
          .doc(user!.uid)
          .update({'totalEarnings': auth.userModel.value!.totalEarnings});
    } catch (e) {
      showErrorMessage('Driver Role Error',
          "Error updating your mode as a rider: $e", Icons.lock_person);
      rethrow;
    }
    return;
  }

  static void checkSubscriptionStatus() async {
    if (userModel!.isDriver) {
      final int storedTime = _box.read(_timerKey) ?? 0;
      final int currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime > storedTime || !userModel!.isSubscribed) {
        SubscriptionController.instance.clearTimer();
        SubscriptionController.instance.resetTimerFields();
        return;
      }
    }
    return;
  }

  static void readRatingInfo() async {
    auth.userRating.value =
        await UserRepository.instance.getUserRating(user!.uid);
  }

  static void getTransactions() async {
    TransactionController.instance.transactionHistory.value =
        await TransactionRepository.instance.getAllTransactions(user!.uid);
  }

  static void getUserCards() async {
    CardController.instance.debitCards.value =
        await CardRepository.instance.getUserCards();
  }

  // ? trip assistants and map
  static Future<DirectionDetailsInfo?> getOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    // Create connection to direction Api
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$GOOGLE_API_KEY";
    // Sending the api Url to the static method to use the url to fetch the driving directions in Json format.
    var response = await RequestAssistant.ReceiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (response == "Error fetching the request") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = response["routes"][0]["overview_polyline"]
        ["points"]; // Poly/Encoded points from Current Location to destination

    directionDetailsInfo.distance_value =
        response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.distance_text =
        response["routes"][0]["legs"][0]["distance"]["text"];

    directionDetailsInfo.duration_value =
        response["routes"][0]["legs"][0]["duration"]["value"];
    directionDetailsInfo.duration_text =
        response["routes"][0]["legs"][0]["duration"]["text"];

    return directionDetailsInfo;
  }

  Future<int> getElapsedTimeFromTimeInMinutes(
      DateTime currentTime, DateTime previousTime) async {
    int diff = currentTime.difference(previousTime).inMinutes;
    return diff;
  }

  static pauseLiveLocationUpdates() {
    MapController.find.streamSubscriptionPosition.value!.pause();
    Geofire.removeLocation(user!.uid);
  }

  static resumeLiveLocationUpdates() {
    MapController.find.streamSubscriptionPosition.value!.resume();
    Geofire.setLocation(
        user!.uid,
        MapController.find.driverCurrentPosition.value!.latitude,
        MapController.find.driverCurrentPosition.value!.longitude);
  }

  static int calculateFareAmountFromSourceToDestination(
      DirectionDetailsInfo directionDetailsInfo, CarType vehicleType) {
    int? baseFare;
    int? FareAmountPerMinute;
    int? FareAmountPerKilometer;

    baseFare = vehicleType.baseFare;
    FareAmountPerMinute = ((directionDetailsInfo.duration_value! / 60) *
            vehicleType.pricePerMinute)
        .round();
    FareAmountPerKilometer =
        ((directionDetailsInfo.distance_value! / 1000) * vehicleType.pricePerKm)
            .round();

    //In taka
    int totalFareAmount =
        baseFare + FareAmountPerMinute + FareAmountPerKilometer;

    return totalFareAmount;
  }

  // For Trip history
  static void readRideRequestKeys(context) async {
    final snapshot = await firestore
        .collection('ride_requests')
        .where('driverId', isEqualTo: user!.uid)
        .get();

    if (snapshot.docs.isEmpty) {
      FirebaseAuth.instance.signOut();
    }

    for (var element in snapshot.docs) {
      Map<String, dynamic> data = element.data();
      int totalTripsCount = data.length;

      // Updating total trips taken by this user
      MapController.find.updateTotalTrips(totalTripsCount);

      // Store all the rideRequest key/id in this list
      List<String> allRideRequestKeyList = [];
      data.forEach((key, value) {
        allRideRequestKeyList.add(key);
      });

      // Storing the total trips taken list in provider
      MapController.find.updateTotalTripsList(allRideRequestKeyList);

      readTripHistoryInformation(context);
    }
  }

  static void readTripHistoryInformation(context) {
    var historyTripsKeyList = MapController.find.historyTripsKeyList;
    for (String eachKey in historyTripsKeyList) {
      firestore
          .collection("ride_requests")
          .doc(eachKey)
          .get()
          .then((snapshotdata) {
        // convert each ride request information to TripHistoryModel
        var eachTripHistoryInformation =
            TripsHistoryModel.fromSnapshot(snapshotdata);

        if (eachTripHistoryInformation.status == TripStatus.completed) {
          // Add each TripHistoryModel to a  historyInformationList in AppInfo class
          MapController.find
              .updateTotalHistoryInformation(eachTripHistoryInformation);
        }
      });
    }
  }

  // static void getLastTripInformation(context) {
  //   FirebaseDatabase.instance
  //       .ref()
  //       .child("AllRideRequests")
  //       .child(driverData.lastTripId!)
  //       .once()
  //       .then((snapData) async {
  //     var lastTripHistoryInformation =
  //         TripsHistoryModel.fromSnapshot(snapData.snapshot);
  //     if ((snapData.snapshot.value as Map)["status"] == "Ended") {
  //       // Add each TripHistoryModel to a  historyInformationList in AppInfo class

  //       LatLng lastTripSourceLatLng = LatLng(
  //           (snapData.snapshot.value as Map)["source"]["latitude"],
  //           (snapData.snapshot.value as Map)["source"]["longitude"]);
  //       LatLng lastTripDestinationLatLng = LatLng(
  //           (snapData.snapshot.value as Map)["destination"]["latitude"],
  //           (snapData.snapshot.value as Map)["destination"]["longitude"]);
  //       var lastTripDirectionDetailsInfo =
  //           await getOriginToDestinationDirectionDetails(
  //               lastTripSourceLatLng, lastTripDestinationLatLng);
  //       MapController.find.updateLastHistoryInformation(
  //           lastTripHistoryInformation, lastTripDirectionDetailsInfo!);
  //     }
  //   });
  // }

  // static void getDriverRating(context) {
  //   FirebaseDatabase.instance
  //       .ref()
  //       .child("Drivers")
  //       .child(currentFirebaseUser!.uid)
  //       .child("totalEarnings")
  //       .once()
  //       .then((snapData) {
  //     DataSnapshot snapshot = snapData.snapshot;
  //     if (snapshot.exists) {
  //       String driverRating = snapshot.value.toString();
  //       MapController.find.updateDriverRating(driverRating);
  //     }
  //   });
  // }
}
