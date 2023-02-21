import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Emergency extends StatelessWidget {
  const Emergency({
    super.key,
    required this.isSwiped,
  });

  final bool isSwiped;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: ListView.builder(itemBuilder: (context, index) {
            return const Card(
                child: ListTile(
              // leading: FlutterLogo(),
              title: Text('Lorem Ipsum'),
              trailing: Icon(Icons.more_vert),
            ));
          })),
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: isSwiped
                  ? SlideAction(
                      borderRadius: 12,
                      elevation: 0,
                      animationDuration: const Duration(milliseconds: 0),
                      innerColor: Colors.white,
                      outerColor: Colors.red,
                      sliderButtonIcon: const Icon(Icons.call),
                      text: "Swipe to call \n emergency services",
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      sliderRotate: false,
                      onSubmit: () {
                        // setState(() {
                        //   isSwiped = false;
                        // });
                      },
                    )
                  : const Text("hello"),
            ),
          ),
        ],
      ),
    );
  }
}
