import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'instruction_service.dart';
import 'package:solutionchallenge/emergency.dart';
import 'package:solutionchallenge/map_page.dart';
import 'package:solutionchallenge/instructions.dart';
import 'package:solutionchallenge/learning.dart';
import 'package:solutionchallenge/topic.dart';
import 'package:solutionchallenge/content.dart';

class RouteUtil {
  // routing to emergency instructions page
  static Route instructionRoute(List<Instruction> instructions, String name) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => InstructionsPage(instructions: instructions, name: name),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeOutCubic;
          Offset begin = const Offset(0, 1.0);
          Offset end = Offset.zero;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }

  // routing to content and video page
  static Route emergencyRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const EmergencyPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }

  // routing to content and video page
  static Route mapRoute(LatLng destination) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MapPage(destination: destination,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }

  // routing to topics page
  static Route topicRoute(Category course, DatabaseReference dbRef) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TopicPage(title: course.name, topicList: course.topics, database: dbRef),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }

  // routing to content and video page
  static Route contentRoute(String title, List<Subtopic> subtopicList, int subtopicIndex, DatabaseReference dbRef) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ContentPageView(topicTitle: title, subtopicList: subtopicList, subtopicIndex: subtopicIndex, database: dbRef),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeOutCubic;
          Offset begin = const Offset(0, 1.0);
          Offset end = Offset.zero;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }
}



