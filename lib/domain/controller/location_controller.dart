import 'dart:async';
import 'package:f_location/data/model/user_location.dart';
import 'package:f_location/domain/use_case/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class LocationController extends GetxController {
  //final userLocation = UserLocation(latitude: 11.0041, longitude: -74.8070).obs;
  final userLocation = UserLocation(latitude: 0, longitude: 0).obs;

  var errorMsg = "".obs;
  var _liveUpdate = false.obs;
  StreamSubscription<UserLocation>? _positionStreamSubscription;
  LocatorService service = Get.find();
  //LocationService service = Get.find();

  bool get liveUpdate => _liveUpdate.value;

  clearLocation() {
    userLocation.value = UserLocation(latitude: 0, longitude: 0);
  }

  getLocation() async {
    try {
      userLocation.value = await service.getLocation();
    } catch (e) {
      //userLocation.value = null;
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
    // if (_positionStreamSubscription != null) {
    //   logError('suscribeLocationUpdates not null');
    //   return;
    // }

    _positionStreamSubscription = service.stream.listen((event) {
//      if (event != null) {
      logInfo("Controller event ${event.latitude}");
      userLocation.value = event;
      // } else {
      //   logError("Controller event is null");
      // }
    });
  }

  unSuscribeLocationUpdates() async {
    print('unSuscribeLocationUpdates');
    _liveUpdate.value = false;
    if (service != null) {
      service.stopStream();
    } else {
      print("unSuscribeLocationUpdates locatorService is null");
    }

    if (_positionStreamSubscription != null) {
      _positionStreamSubscription?.cancel();
      //_positionStreamSubscription = null;
    } else {
      print("Controller _positionStreamSubscription is null");
    }
  }
}
