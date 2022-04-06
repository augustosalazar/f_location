import 'package:f_location/data/model/user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:loggy/loggy.dart';

class LocatorService {
  StreamSubscription<Position>? _positionStreamSubscription;

  final StreamController<UserLocation> _locationStreamController =
      StreamController<UserLocation>.broadcast();

  Geolocator geolocator = Geolocator();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;

  Future<UserLocation> getLocation() async {
    UserLocation userLocation;
    try {
      Position l = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userLocation = UserLocation(latitude: l.latitude, longitude: l.longitude);
      return Future.value(userLocation);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> startStream() async {
    logInfo("startStream with Locator library");

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .handleError((onError) {
      logError("Got error from Geolocator stream");
      return Future.error(onError.toString());
    }).listen((Position? position) {
      if (position != null) {
        _locationStreamController.add(UserLocation.fromPosition(position));
      }
    });
  }

  stopStream() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    } else {
      logError("stopStream _positionStreamSubscription is null");
    }
  }
}
