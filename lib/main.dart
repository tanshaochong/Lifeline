import 'package:solutionchallenge/Widget_Tree.dart';

import 'home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'Widget_Tree.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Aid App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      // home: const HomeView());
      home: const WidgetTree(),
    );
  }
}

// "AIzaSyBzCUkxMWFZ1Jz3sobOSkBoqH24T8pilcY"