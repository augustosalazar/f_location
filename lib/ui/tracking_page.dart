import 'package:f_location/domain/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
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
                      child: const Text("Current location")),
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
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(
                          locationController.userLocation.value.latitude,
                          locationController.userLocation.value.longitude),
                      interactiveFlags: InteractiveFlag.rotate |
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.doubleTapZoom,
                      //   zoom: 13.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        attributionBuilder: (_) {
                          return const Text("© OpenStreetMap contributors");
                        },
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: LatLng(
                                locationController.userLocation.value.latitude,
                                locationController
                                    .userLocation.value.longitude),
                            builder: (ctx) => const FlutterLogo(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GetX<LocationController>(
                builder: (controller) {
                  if (controller.userLocation.value.latitude != 0) {
                    _mapController.move(
                        LatLng(controller.userLocation.value.latitude,
                            controller.userLocation.value.longitude),
                        14.0);
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
