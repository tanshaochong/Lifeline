import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'instructions.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Emergency {
  final String name;
  final List<Instruction> instructions;

  Emergency({required this.name, required this.instructions});
}

class Instruction {
  final String text;
  final String url;

  Instruction({required this.text, required this.url});
}

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

  Future<void> loadInstructions() async {
    final instructionsJson =
        await rootBundle.loadString('assets/instructions.json');

    // Parse the JSON string into a Map
    Map<String, dynamic> jsonData = json.decode(instructionsJson);

    // Access the emergencies list from the Map
    List<dynamic> emergenciesList = jsonData['emergencies'];

    // Create a List of Emergency objects
    List<Emergency> emergencies = emergenciesList.map((emergencyData) {
      // Extract the name and instructions fields from the emergency data
      String name = emergencyData['name'];
      List<dynamic> instructionsList = emergencyData['instructions'];

      // Create a List of Instruction objects
      List<Instruction> instructions = instructionsList.map((instructionData) {
        // Extract the text and pictureUrl fields from the instruction data
        String text = instructionData['text'];
        String url = instructionData['url'];

        // Create a new Instruction object with the extracted fields
        return Instruction(text: text, url: url);
      }).toList();

      // Create a new Emergency object with the extracted fields and List of Instruction objects
      return Emergency(name: name, instructions: instructions);
    }).toList();

    setState(() {
      emergencyList = emergencies;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInstructions();
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
                        // leading: FlutterLogo(),
                        title: Text(emergencyList[index].name),
                        trailing: const Icon(Icons.more_vert),
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
