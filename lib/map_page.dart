import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng origin = const LatLng(1.3541, 103.6882);
  final LatLng destination = const LatLng(1.3489, 103.6895);

  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  List<LatLng> polylineCoordinates = [];

  late String _mapStyle;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void isServiceEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  void isPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void getCurrentLocation() async {
    location.getLocation().then((location) {
      currentLocation = location;
      getPolyPoints();
    });

    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((newLocation) async {
      currentLocation = newLocation;
    });
  }
//----------

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBzCUkxMWFZ1Jz3sobOSkBoqH24T8pilcY",
        PointLatLng(currentLocation?.latitude ?? destination.latitude,
            currentLocation?.longitude ?? destination.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  @override
  void initState() {
    // isServiceEnabled();
    // isPermissionGranted();
    location.changeSettings(distanceFilter: 5, accuracy: LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
    getCurrentLocation();

    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: currentLocation == null
          ? const Center(
              child: Text("Loading"),
            )
          : SlidingUpPanel(
              minHeight: 192,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              panel: Container(
                padding: const EdgeInsets.only(
                    left: 24, top: 12, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.3))),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text("Blk 21A, 66 Nanyang Crescent",
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "5 min ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "(250 m)",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Time",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.3))),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              "05:37 pm (3 mins ago)",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text("Additional Information",
                        style: TextStyle(color: Colors.black.withOpacity(0.3))),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black.withOpacity(0.2)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      child: const ListTile(
                        title: Text("Age"),
                        subtitle: Text("Middle-aged"),
                        trailing: Icon(
                          Icons.schedule_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black.withOpacity(0.2)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      child: const ListTile(
                        title: Text("Gender"),
                        subtitle: Text("Male"),
                        trailing: Icon(
                          Icons.male_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black.withOpacity(0.2)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      child: const ListTile(
                        title: Text("Height"),
                        subtitle: Text("Around 1.7 m"),
                        trailing: Icon(
                          Icons.height_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 15.0,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        width: 5,
                        color: Colors.redAccent,
                        jointType: JointType.round,
                        startCap: Cap.roundCap,
                        endCap: Cap.roundCap,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("destination"),
                        position: destination,
                      ),
                    }),
              )),
    );
  }
}
