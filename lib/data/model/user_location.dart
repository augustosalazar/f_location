import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});

  static UserLocation fromPosition(Position position) {
    return UserLocation(
        latitude: position.latitude, longitude: position.longitude);
  }
}
