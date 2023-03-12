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
        title: const Text('Emergency'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: ListView.builder(itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructionsPage()));
                },
                // leading: FlutterLogo(),
                title: Text('Lorem Ipsum'),
                trailing: Icon(Icons.more_vert),
              ));
            })),
            EmergencySwipeToCall(isSwiped: isSwiped),
          ],
        ),
      ),
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
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: isSwiped
            ? SlideAction(
                borderRadius: 12,
                elevation: 0,
                animationDuration: const Duration(milliseconds: 0),
                innerColor: Colors.white,
                outerColor: Colors.red,
                sliderButtonIcon: const Icon(Icons.call),
                text: "            Swipe to call emergency services",
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
      ),
    );
  }
}
