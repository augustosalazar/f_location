import 'package:f_location/data/model/user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocatorService {
  final _controller = StreamController<UserLocation>();

  StreamSubscription<Position>? _positionStreamSubscription;

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Geolocator geolocator = Geolocator();

  //Stream<UserLocation> get stream => _controller.stream.asBroadcastStream();
  Stream<UserLocation> get stream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    UserLocation userLocation;
    try {
      Position l = await Geolocator.getCurrentPosition();
      userLocation = UserLocation(latitude: l.latitude, longitude: l.longitude);
      return Future.value(userLocation);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> startStream() async {
    print("startStream with Locator library");
    _positionStreamSubscription =
        Geolocator.getPositionStream().handleError((onError) {
      print("Got error from Geolocator stream");
      return Future.error(onError.toString());
    }).listen((event) {
      //_controller.sink.add(UserLocation.fromPosition(event));
      _locationController.add(UserLocation.fromPosition(event));
    });
  }

  stopStream() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    } else {
      print("stopStream _positionStreamSubscription is null");
    }
  }
}
