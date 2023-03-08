import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/map_page.dart';
import 'package:solutionchallenge/map_widget.dart';
import 'learning.dart';
import 'emergency.dart';
import 'instructions.dart';
import 'auth.dart';
import 'profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Column(children: const [
            SizedBox(height: 8),
            Text('Welcome'),
            Text(
              'Jialu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            )
          ]),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Emergency(isSwiped: true)));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'FAKit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Sign out'),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
      body: PageView(
        physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast, parent: AlwaysScrollableScrollPhysics()),
        controller: _controller,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 9, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 25,
                ),
                TopWidget(),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    aedWidget(),
                    cprWidget(),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        child: EmergencyWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LearningPage(),
        ]
      ),
    );
  }
}

class EmergencyWidget extends StatelessWidget {
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Emergency(isSwiped: true)));
        },
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.red,
          margin: EdgeInsets.all(8),
          child: Center(
              child: Text(
            'Emergency',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          )),
        ),
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
    return Container(
      height: 350,
      margin: EdgeInsets.all(8),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        // child: const MapWidget(),
        child: const Placeholder(),
      ),
    );
  }
}

class aedWidget extends StatefulWidget {
  const aedWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _aedWidgetState createState() => _aedWidgetState();
}

class _aedWidgetState extends State<aedWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 150,
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InstructionsPage()));
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

class cprWidget extends StatefulWidget {
  const cprWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _cprWidgetState createState() => _cprWidgetState();
}

class _cprWidgetState extends State<cprWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 150,
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InstructionsPage()));
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
