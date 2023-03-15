import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'instructions.dart';

class Emergency extends StatelessWidget {
  const Emergency({
    super.key,
    required this.isSwiped,
  });

  final bool isSwiped;

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
            const ModeBanner(),
            Expanded(child: ListView.builder(itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InstructionsPage()));
                },
                // leading: FlutterLogo(),
                title: const Text('Lorem Ipsum'),
                trailing: Icon(Icons.more_vert),
              ));
            })),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmergencySwipeToCall(isSwiped: isSwiped),
          ),
        ),
      ]),
    );
  }
}

class EmergencySwipeToCall extends StatelessWidget {
  const EmergencySwipeToCall({
    super.key,
    required this.isSwiped,
  });

  final bool isSwiped;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: isSwiped
          ? SlideAction(
              borderRadius: 50,
              elevation: 0,
              animationDuration: const Duration(milliseconds: 0),
              innerColor: Colors.white,
              outerColor: Colors.red,
              sliderButtonIcon: const Icon(Icons.call),
              text: "Swipe to call \n emergency services",
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              sliderRotate: false,
              onSubmit: () {
                // setState(() {
                //   isSwiped = false;
                // });
              },
            )
          : const Text("hello"),
    );
  }
}

class ModeBanner extends StatelessWidget {
  const ModeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialBanner(
            leading: const Icon(
              Icons.health_and_safety_outlined,
              color: Colors.red,
            ),
            content: const Text("Requesting help for yourself"),
            actions: [
              TextButton(onPressed: () => {}, child: const Text("Change"))
            ]),
        const Divider(thickness: 2, height: 2, color: Colors.red),
      ],
    );
  }
}
