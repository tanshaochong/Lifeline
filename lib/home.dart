import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solutionchallenge/profile.dart';
import 'learning.dart';
import 'emergency.dart';
import 'auth.dart';
import 'map_widget.dart';
import 'utils/instruction_service.dart';
import 'utils/routing.dart';
import 'package:flutter/services.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Emergency> emergencyList = [];

  Future<void> _loadInstructions() async {
    List<Emergency> emergencies = await InstructionService.getInstructions(
        'assets/instructions_homepage.json');

    setState(() {
      emergencyList = emergencies;
    });
  }

  final _controller = PageController(
    initialPage: 0,
  );

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadInstructions();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey.shade200,
              elevation: 0,
              title: Image.asset(
                'assets/appbaricon.png',
                height: 35,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  username: 'dev',
                                  email: user?.email!,
                                  profileImageUrl: '')));
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ))
              ]),
          body: Column(
            children: [
              const TabBar(tabs: [
                Tab(
                  icon: Icon(
                    Icons.health_and_safety,
                    color: Colors.red,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.book,
                    color: Colors.red,
                  ),
                ),
              ]),
              Expanded(
                child: TabBarView(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      HomeEmergencyPage(emergencyList: emergencyList),
                      LearningPage(user: user),
                    ]),
              )
            ],
          )),
    );
  }
}

class HomeEmergencyPage extends StatefulWidget {
  const HomeEmergencyPage({
    super.key,
    required this.emergencyList,
  });

  final List<Emergency> emergencyList;

  @override
  State<HomeEmergencyPage> createState() => _HomeEmergencyPageState();
}

class _HomeEmergencyPageState extends State<HomeEmergencyPage> {
  bool _hasEmergency = false;

  bool _onEmergencyPing(bool newValue) {
    setState(() {
      _hasEmergency = newValue;
    });

    return newValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hasEmergency ? const NotificationBanner() : Container(),
          const SizedBox(
            height: 8,
          ),
          TopWidget(onEmergency: (newValue){
            setState(() {
              _onEmergencyPing(newValue);
            });
          }),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: InstructionWidget(emergencyList: widget.emergencyList),
          ),
          const SizedBox(
            height: 8,
          ),
          const Expanded(
            child: EmergencyWidget(),
          ),
        ],
      ),
    );
  }
}

class TopWidget extends StatefulWidget {
  final Function(bool) onEmergency;

  const TopWidget({super.key, required this.onEmergency});

  @override
  State<TopWidget> createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(RouteUtil.mapRoute(const LatLng(1.3489, 103.6895)));
      },
      child: SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: MapWidget(
                onEmergency: (newValue){
                  setState(() {
                    widget.onEmergency(newValue);
                  });
                }
            ),
          )
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    super.key,
    required this.emergencyList,
  });

  final List<Emergency> emergencyList;

  @override
  Widget build(BuildContext context) {
    // Dynamically populate buttons
    List<Widget> instructionWidgetList = List.generate(
      emergencyList.length,
      (int index) => Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(RouteUtil.instructionRoute(emergencyList[index].instructions, emergencyList[index].name, true));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emergencyList[index].name == 'CPR'
                    ? Icons.favorite
                    : Icons.offline_bolt_rounded,
                size: 40,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emergencyList[index].name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'View instructions',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    instructionWidgetList = instructionWidgetList
        .expand((widget) => [
              widget,
              const SizedBox(
                width: 8,
              )
            ])
        .toList();

    if (instructionWidgetList.isNotEmpty) instructionWidgetList.removeLast();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: instructionWidgetList,
    );
  }
}

class EmergencyWidget extends StatelessWidget {
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(RouteUtil.emergencyRoute());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.emergency_rounded,
            size: 40,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Emergency',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}