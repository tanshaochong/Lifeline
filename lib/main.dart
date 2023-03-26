import 'package:flutter/services.dart';
import 'package:solutionchallenge/login.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'profile.dart';

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Aid App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // home: const HomeView());
      home: const login_tree(),
    );
  }
}

// "AIzaSyBzCUkxMWFZ1Jz3sobOSkBoqH24T8pilcY"