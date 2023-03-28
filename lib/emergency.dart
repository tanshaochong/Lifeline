import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';

import 'utils/routing.dart';
import 'utils/instruction_service.dart';


class EmergencyPage extends StatefulWidget {
  const EmergencyPage({
    super.key,
  });

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  List<Emergency> emergencyList = [];

  Future<void> _loadInstructions() async {
    List<Emergency> emergencies =
        await InstructionService.getInstructions('assets/instructions.json');

    setState(() {
      emergencyList = emergencies;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInstructions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // const ModeBanner(),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: emergencyList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.grey.shade50,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(RouteUtil.instructionRoute(emergencyList[index].instructions, emergencyList[index].name));
                        },
                        leading: Icon(
                          Icons.healing,
                          size: 40,
                          color: Colors.red.shade400,
                        ),
                        title: Text(
                          emergencyList[index].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                            '${emergencyList[index].instructions.length} Steps'),
                        trailing: const Icon(Icons.more_vert),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 85,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmergencySwipeToCall(),
          ),
        ),
      ]),
    );
  }
}

class EmergencySwipeToCall extends StatefulWidget {
  EmergencySwipeToCall({super.key, this.isSwiped = true});

  bool isSwiped;

  @override
  State<EmergencySwipeToCall> createState() => _EmergencySwipeToCallState();
}

class _EmergencySwipeToCallState extends State<EmergencySwipeToCall> {
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  late Future<LocationData> _currentLocation;

  late bool _isSwiped;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  late final DatabaseReference dbRef =
      database.ref().child('emergency'); // emergency data reference

  @override
  void initState() {
    super.initState();

    _isSwiped = false;
    _currentLocation = _getLocation();

    // location listener to listen for user movement
    _locationSubscription =
        location.onLocationChanged.listen((newLocation) async {
      setState(() {
        _currentLocation = _getLocation();
      });
    });
  }

  Future<LocationData> _getLocation() async {
    LocationData currentLocation = await location.getLocation();
    return currentLocation;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _currentLocation,
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          final locationData = snapshot.data;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Container(
              padding: const EdgeInsets.all(8),
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: widget.isSwiped
                  ? SlideAction(
                  borderRadius: 50,
                  elevation: 0,
                  animationDuration: const Duration(milliseconds: 0),
                  innerColor: Colors.white,
                  outerColor: Colors.red,
                  sliderButtonIcon: const Icon(Icons.call),
                  text: "Swipe to request\n emergency help",
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  sliderRotate: false,
                  onSubmit: () {
                    setState(() {
                      widget.isSwiped = false;
                    });
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Emergency Help',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)
                          ),
                          content: const Text(
                              'Are you requesting emergency help for yourself?'
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text(
                                'No, it is for someone else',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                double? longitude = locationData?.longitude;
                                double? latitude = locationData?.latitude;

                                LatLng position = LatLng(latitude!, longitude!);

                                sendEmergency(position);

                                Navigator.pop(context, 'Yes');
                              },
                              child: const Text(
                                'Yes, it is for myself',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ));
                  })
                  : Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Emergency help has\nbeen requested",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          );
        }
        else{
          return const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 49),
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Future<void> sendEmergency(LatLng coords) async {
    final emergencyData = {
      'latitude': coords.latitude,
      'longitude': coords.longitude,
      'patient': Auth().currentUser?.uid,
      'responder': "",
    };

    dbRef.push().set(emergencyData);
  }
}

class ModeBanner extends StatefulWidget {
  const ModeBanner({
    super.key,
  });

  @override
  State<ModeBanner> createState() => _ModeBannerState();
}

class _ModeBannerState extends State<ModeBanner> {
  bool mode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: MaterialBanner(
              leading: const Icon(
                Icons.health_and_safety_outlined,
                color: Colors.red,
              ),
              content: mode
                  ? const Text(
                "Requesting help for yourself",
                style: TextStyle(fontWeight: FontWeight.bold),)
                  : const Text(
                "Requesting help for someone",
                style: TextStyle(fontWeight: FontWeight.bold),),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        mode = !mode;
                      });
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ]),
        ),
      ),
    );
  }
}

class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: MaterialBanner(
            leading: const Icon(
              Icons.health_and_safety_outlined,
              color: Colors.red,
            ),
            content: const Text(
              "Emergency help needed near you (500 m)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(RouteUtil.mapRoute(const LatLng(1.3489, 103.6895)));
                  },
                  child: const Text(
                    "Respond",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ]),
      ),
    );
  }
}
