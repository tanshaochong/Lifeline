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
  List<LatLng> polylineCoordinates = [];
  Location location = Location();
  LocationData? currentLocation;

  BitmapDescriptor emergencyIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  late String _mapStyle;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void getCurrentLocation() {
    location.getLocation().then((location) {
      currentLocation = location;
      getPolyPoints();
      print("b");
    });

    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      print("c");
      // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //     target: LatLng(newLocation.latitude!, newLocation.longitude!))));
      setState(() {});
    });
  }

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
    print("a");
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/outline_emergency_black_24dp.png")
        .then((icon) {
      emergencyIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "assets/outline_trip_origin_black_24dp.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    // getPolyPoints();
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
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
                      height: 4,
                    ),
                    Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.2),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.red,
                                      child: Text("A"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "Paviru Uduwe Perera",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
                                      child: const ListTile(
                                        title: Text("Age"),
                                        subtitle: Text("42"),
                                        trailing: Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
                                      child: const ListTile(
                                        title: Text("Weight"),
                                        subtitle: Text("100 kg"),
                                        trailing: Icon(
                                          Icons.scale_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
                                      child: const ListTile(
                                        title: Text("Height"),
                                        subtitle: Text("1.24 m"),
                                        trailing: Icon(
                                          Icons.height_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
                                      child: const ListTile(
                                        title: Text("Blood Type"),
                                        subtitle: Text("O+"),
                                        trailing: Icon(
                                          Icons.bloodtype_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
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
                      // Marker(
                      //   markerId: const MarkerId("currentLocation"),
                      //   icon: currentLocationIcon,
                      //   position: LatLng(currentLocation?.latitude ?? 1.3547,
                      //       currentLocation?.longitude ?? 103.6848),
                      // ),
                      // Marker(
                      //   markerId: const MarkerId("user"),
                      //   position: origin,
                      // ),
                      Marker(
                        markerId: const MarkerId("destination"),
                        // icon: emergencyIcon,
                        position: destination,
                      ),
                    }),
              )),
    );
  }
}
