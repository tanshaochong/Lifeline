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
            const ModeBanner(),
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
                title: const Text('Lorem Ipsum'),
                trailing: const Icon(Icons.more_vert),
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
                        text: "Swipe to call \n for help",
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        sliderRotate: false,
                        onSubmit: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Nature of Emergency"),
                              content: Text(
                                  "Are you calling help for yourself or someone else?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        {Navigator.of(context).pop()},
                                    child: Text("No, someone else needs help")),
                                TextButton(
                                    onPressed: () =>
                                        {Navigator.of(context).pop()},
                                    child: Text("Yes, I need help")),
                              ],
                            ),
                            // barrierDismissible: false
                          );
                        },
                      )
                    : const Text("hello"),
              ),
            ),
          ],
        ),
      ),
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
