import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../controllers/location_controller.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
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
                        try {
                          locationController.getLocation();
                        } catch (e) {
                          Get.snackbar('Error.....', e.toString(),
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      child: const Text("Current")),
                ],
              ),
              Obx(() => ElevatedButton(
                  key: const Key("changeLiveUpdate"),
                  onPressed: () async {
                    if (!locationController.liveUpdate) {
                      await locationController
                          .subscribeLocationUpdates()
                          .onError((error, stackTrace) {
                        Get.snackbar('Error.....', error.toString(),
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white);
                      });
                    } else {
                      await locationController
                          .unSubscribeLocationUpdates()
                          .onError((error, stackTrace) {
                        Get.snackbar('Error.....', error.toString(),
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white);
                      });
                    }
                  },
                  child: Text(locationController.liveUpdate
                      ? "Set live updates off"
                      : "Set live updates on"))),
              Center(
                child: Obx(() => Text('${locationController.userLocation}')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
