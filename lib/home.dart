import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/map_page.dart';
import 'package:solutionchallenge/profile.dart';
import 'learning.dart';
import 'emergency.dart';
import 'instructions.dart';
import 'auth.dart';
import 'map_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
              backgroundColor: Colors.grey.shade200,
              elevation: 0,
              title: const Text(
                'F A K I T',
                style: TextStyle(
                  color: Colors.black,
                ),
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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(9, 0, 9, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              NotificationBanner(),
                              const TopWidget(),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const AedWidget(),
                                  const CprWidget(),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Expanded(
                                      child: EmergencyWidget(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const LearningPage(),
                    ]),
              )
            ],
          )),
    );
  }
}

class EmergencyWidget extends StatelessWidget {
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Emergency(isSwiped: true)));
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.red,
        margin: const EdgeInsets.all(8),
        child: const Center(
            child: Text(
          'Emergency',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        )),
      ),
    );
  }
}

class TopWidget extends StatefulWidget {
  const TopWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TopWidgetState createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MapPage()));
      },
      child: Container(
          height: 250,
          margin: const EdgeInsets.all(8),
          child: const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: MapWidget(),
          )
          // Card(
          //   semanticContainer: true,
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   elevation: 10,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(20.0),
          //   ),
          //   color: Colors.white,
          //   child: const MapWidget(),
          //   // child: const Placeholder(),
          // ),
          ),
    );
  }
}

class AedWidget extends StatefulWidget {
  const AedWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AedWidgetState createState() => _AedWidgetState();
}

class _AedWidgetState extends State<AedWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 150,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InstructionsPage()));
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.white,
            // ignore: sort_child_properties_last
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: 15),
                const Icon(Icons.favorite,
                    size: 40, color: Colors.red), //heart attack icon
                const SizedBox(width: 15), //spacing between icon and text
                Column(
                  children: const [
                    SizedBox(height: 35),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'AED',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Emergency',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
            margin: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}

class CprWidget extends StatefulWidget {
  const CprWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CprWidgetState createState() => _CprWidgetState();
}

class _CprWidgetState extends State<CprWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 150,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InstructionsPage()));
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.white,
            // ignore: sort_child_properties_last
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: 15),
                const Icon(Icons.handshake,
                    size: 40, color: Colors.red), //heart attack icon
                const SizedBox(width: 15), //spacing between icon and text
                Column(
                  children: const [
                    SizedBox(height: 35),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CPR',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Emergency',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
            margin: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}

// class AppBar extends StatefulWidget {
//   const AppBar({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AppBarState createState() => _AppBarState();
// }

// class _AppBarState extends State<AppBar> {
//   @override
//   Widget build(BuildContext context) {

//   }
// }
