import 'dart:async';
import 'package:f_location/data/model/user_location.dart';
import 'package:f_location/domain/use_case/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class LocationController extends GetxController {
  final userLocation = UserLocation(latitude: 0, longitude: 0).obs;

  var errorMsg = "".obs;
  var _liveUpdate = false.obs;
  StreamSubscription<UserLocation>? _positionStreamSubscription;
  LocatorService service = Get.find();
  bool get liveUpdate => _liveUpdate.value;

  clearLocation() {
    userLocation.value = UserLocation(latitude: 0, longitude: 0);
  }

  getLocation() async {
    try {
      userLocation.value = await service.getLocation();
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
