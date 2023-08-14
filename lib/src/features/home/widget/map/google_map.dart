import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/controller/map_controller.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    super.key,
    required this.map,
  });

  final MapController map;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget>
    with
        AutomaticKeepAliveClientMixin<GoogleMapWidget>,
        SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(
      () => Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
                bottom: widget.map.bottomSheetHeight.value + 20),
            buildingsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              if (!widget.map.controllerGoogleMap.value.isCompleted) {
                widget.map.controllerGoogleMap.value.complete(controller);
              }
              widget.map.newGoogleMapController.value = controller;
              if (!widget.map.pickupSelected.value) {
                widget.map.locateUserPosition();
              }

              widget.map.bottomSheetHeight.value =
                  !AuthController.find.userModel.value!.isDriver ? 220 : 230;
            },
            onTap: (LatLng latlng) {
              widget.map.bottomSheetHeight.value =
                  !AuthController.find.userModel.value!.isDriver ? 220 : 230;
              widget.map.pickLocation.value = latlng;
              widget.map.cameraPositionDefault.value = CameraPosition(
                target: latlng,
                zoom: 17.765,
                tilt: 0.3,
              );
              widget.map.newGoogleMapController.value!.animateCamera(
                  CameraUpdate.newCameraPosition(
                      widget.map.cameraPositionDefault.value));
            },
            initialCameraPosition: widget.map.cameraPositionDefault.value,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: widget.map.pLineCoordinatedList.toList(),
                color: AppColors.secondaryColor,
                width: 6,
              ),
            }, // Set<Polyline>.of(widget.map.polylineSet),
            markers: Set<Marker>.of(widget.map.markers),
            circles: Set<Circle>.of(widget.map.circles),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
        ],
      ),
    );
  }
}
