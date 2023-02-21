import 'package:flutter/material.dart';
import 'learning.dart';
import 'emergency.dart';
import 'instructions.dart';

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
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'SwiftAid',
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
          ],
        ),
      ),
      body: PageView(
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
                    MediumWidget(),
                    MediumWidget(),
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
                  builder: (context) =>
                      Emergency(isSwiped: true)));
        },
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Color.fromARGB(255, 255, 67, 67),
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
        child: (Image.network(
          'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg',
          fit: BoxFit.fill,
        )),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        // child: Padding(
        //   padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        // child: Container(
        //   height: 20,
        //   width: 20,
        //   child: (Image.network(
        //       'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg')),
        // ),
      ),
    );
  }
}

class MediumWidget extends StatefulWidget {
  const MediumWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MediumWidgetState createState() => _MediumWidgetState();
}

class _MediumWidgetState extends State<MediumWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 150,
        child: TextButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InstructionsPage()));
          },
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            color: Colors.red,
            child: Center(
              child: Text('Medium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            ),
            margin: EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
