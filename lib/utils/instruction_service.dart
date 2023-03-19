import 'dart:convert';
import 'package:flutter/services.dart';

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

class InstructionService {
  static Future<List<Emergency>> getInstructions(String filename) async {
    final instructionsJson = await rootBundle.loadString(filename);

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

    return emergencies;
  }
}
