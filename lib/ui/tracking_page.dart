import 'package:f_location/domain/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late GoogleMapController googleMapController;

  void _onMapCreated(GoogleMapController controller) {
    LocationController locationController = Get.find();
    googleMapController = controller;
    // if (locationController.markers.values.isNotEmpty) {
    //   controller.animateCamera(CameraUpdate.newLatLngBounds(
    //       _bounds(Set<Marker>.of(locationController.markers.values)), 50));
    // }
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    logInfo('Creating new bounds');
    return _createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      key: const Key("clear"),
                      onPressed: () async {
                        locationController.clearLocation();
                      },
                      child: const Text("Clear")),
                  ElevatedButton(
                      key: const Key("currentLocation"),
                      onPressed: () async {
                        locationController.getLocation();
                      },
                      child: const Text("Get markers")),
                  Obx(() => ElevatedButton(
                      key: const Key("changeLiveUpdate"),
                      onPressed: () {
                        if (!locationController.liveUpdate) {
                          locationController.suscribeLocationUpdates();
                        } else {
                          locationController.unSuscribeLocationUpdates();
                        }
                      },
                      child: Text(locationController.liveUpdate
                          ? "Set live updates off"
                          : "Set live updates on"))),
                ],
              ),
              Obx(
                () => Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(locationController.markers.values),
                    myLocationEnabled: true,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(11.0227767, -74.81611),
                      zoom: 17.0,
                    ),
                    // markers: Set.from(
                    //   [
                    //     Marker(
                    //       icon: BitmapDescriptor.defaultMarker,
                    //       markerId: MarkerId('google_plex'),
                    //       position: LatLng(11.022527, -74.816371),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
              GetX<LocationController>(
                builder: (controller) {
                  if (locationController.markers.values.isNotEmpty) {
                    if (controller.userLocation.value.latitude != 0) {}
                    googleMapController.animateCamera(
                        CameraUpdate.newLatLngBounds(
                            _bounds(Set<Marker>.of(
                                locationController.markers.values)),
                            50));
                  } else {
                    if (controller.userLocation.value.latitude != 0) {
                      googleMapController.moveCamera(CameraUpdate.newLatLng(
                          LatLng(controller.userLocation.value.latitude,
                              controller.userLocation.value.longitude)));
                    }
                  }
                  logInfo("UI <" +
                      controller.userLocation.value.latitude.toString() +
                      " " +
                      controller.userLocation.value.longitude.toString() +
                      ">");

                  return Text(
                    controller.userLocation.value.latitude.toString() +
                        " " +
                        controller.userLocation.value.longitude.toString(),
                    key: const Key("position"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
