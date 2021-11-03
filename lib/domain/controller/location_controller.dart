import 'dart:async';
import 'dart:math';
import 'package:f_location/data/model/user_location.dart';
import 'package:f_location/domain/use_case/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loggy/loggy.dart';
//import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  final userLocation = UserLocation(latitude: 0, longitude: 0).obs;
  var errorMsg = "".obs;
  var _liveUpdate = false.obs;
  //var markers = <Marker>[].obs;
  var markers = <MarkerId, Marker>{}.obs;
  StreamSubscription<UserLocation>? _positionStreamSubscription;
  LocatorService service = Get.find();
  bool get liveUpdate => _liveUpdate.value;
  bool changeMarkers = false;

  clearLocation() {
    userLocation.value = UserLocation(latitude: 0, longitude: 0);
  }

  updatedMarker() {
    markers.clear();
    logInfo("Updading marker list");
    if (changeMarkers) {
      Marker marker = const Marker(
        infoWindow: InfoWindow(title: '0', snippet: '*'),
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('0'),
        position: LatLng(10.926312658949284, -74.80101286794627),
      );
      markers[const MarkerId('0')] = marker;

      Marker marker1 = const Marker(
        infoWindow: InfoWindow(title: '1', snippet: '*'),
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('1'),
        position: LatLng(10.930633152447768, -74.81758873396359),
      );
      markers[const MarkerId('1')] = marker1;

      Marker marker2 = const Marker(
        infoWindow: InfoWindow(title: '2', snippet: '*'),
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('2'),
        position: LatLng(10.936442649033246, -74.79614263876492),
      );
      markers[const MarkerId('2')] = marker2;
    }
    changeMarkers = !changeMarkers;
  }

  getLocation() async {
    try {
      userLocation.value = await service.getLocation();
      updatedMarker();
    } catch (e) {
      Get.snackbar('Error.....', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  suscribeLocationUpdates() async {
    _liveUpdate.value = true;
    logInfo('suscribeLocationUpdates');
    await service.startStream().onError((error, stackTrace) {
      logError("Controller got the error ${error.toString()}");
      return;
    });

    _positionStreamSubscription = service.stream.listen((event) {
      logInfo("Controller event ${event.latitude}");
      userLocation.value = event;
    });
  }

  unSuscribeLocationUpdates() async {
    logInfo('unSuscribeLocationUpdates');
    _liveUpdate.value = false;
    service.stopStream();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription?.cancel();
    } else {
      logError("Controller _positionStreamSubscription is null");
    }
  }
}
