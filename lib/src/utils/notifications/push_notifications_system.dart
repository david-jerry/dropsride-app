import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final audioPlayer = AssetsAudioPlayer();

  Future initializeCloudMessaging(BuildContext context) async {
    // Terminated - When the app is completely closed and the app resumes from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // display ride request information
        retrieveRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    // Background - When the app is minimized and the app resumes from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      retrieveRideRequestInformation(
          remoteMessage.data["rideRequestId"], context);
    });

    // Foreground - When the app is open and receives a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      retrieveRideRequestInformation(
          remoteMessage.data["rideRequestId"], context);
    });
  }

  Future generateRegistrationToken() async {
    String? registrationToken = await firebaseMessaging
        .getToken(); // Generate and get registration token

    try {
      await _firestore
          .collection('users')
          .doc(AuthController.find.user.value!.uid)
          .update({'pushToken': registrationToken});
      AssistantMethods.refreshUserInfo();
    } catch (e) {
      showErrorMessage(
          'Push Notification Error',
          "Error creating a authentication token for push notification: $e",
          Icons.lock_person);
      rethrow;
    }

    if (AuthController.find.userModel.value!.isDriver) {
      firebaseMessaging.subscribeToTopic("allDrivers");
    }
    firebaseMessaging.subscribeToTopic("allUsers");
  }

  retrieveRideRequestInformation(String rideRequestID, BuildContext context) {
    _firebaseDatabase
        .ref()
        .child("trips")
        .child(rideRequestID)
        .once()
        .then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if (snapshot.exists) {
        audioPlayer.open(Audio("music/music_notification.mp3"));
        audioPlayer.play();

        String? rideRequestID = snapshot.key;

        double sourceLat = (snapshot.value! as Map)["pickUpLat"];
        double sourceLng = (snapshot.value! as Map)["pickUpLon"];
        String sourceAddress = (snapshot.value! as Map)["pickup"];

        double destinationLat = (snapshot.value! as Map)["dropOffLat"];
        double destinationLng = (snapshot.value! as Map)["dropOffLon"];
        String destinationAddress = (snapshot.value! as Map)["dropOff"];

        String userName = (snapshot.value! as Map)["riderName"];
        String userPhone = (snapshot.value! as Map)["riderPhone"];
        String userPhoto = (snapshot.value! as Map)["riderPhoto"];

        MapController.find.tripInformation.value.rideRequestId = rideRequestID;
        MapController.find.tripInformation.value.userName = userName;
        MapController.find.tripInformation.value.userPhone = userPhone;
        MapController.find.tripInformation.value.userPhoto = userPhoto;
        MapController.find.tripInformation.value.sourceLatLng =
            LatLng(sourceLat, sourceLng);
        MapController.find.tripInformation.value.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        MapController.find.tripInformation.value.sourceAddress = sourceAddress;
        MapController.find.tripInformation.value.destinationAddress =
            destinationAddress;

        // ? open the ride request alert information for the driver to accept the ride request
        MapController.find.showTripInfoAlertToDriver.value = true;

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => NotificationDialogBox(
        //     rideRequestInformation: MapController.find.tripInformation.value,
        //   ),
        // );
      } else {
        showErrorMessage("Invalid Request Information",
            "This ride request is invalid!", FontAwesomeIcons.cableCar);
      }
    });
  }
}
