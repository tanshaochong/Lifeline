import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'instructions.dart';

import 'utils/instruction_service.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({
    super.key,
    required this.isSwiped,
  });

  final bool isSwiped;

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
            const ModeBanner(),
            Expanded(
              child: ListView.builder(
                  itemCount: emergencyList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.grey.shade50,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstructionsPage(
                                      name: emergencyList[index].name,
                                      instructions:
                                          emergencyList[index].instructions,
                                    )),
                          );
                        },
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
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmergencySwipeToCall(isSwiped: widget.isSwiped),
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
