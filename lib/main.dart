import 'package:flutter/services.dart';
import 'package:solutionchallenge/login.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        primarySwatch: Palette.kToDark,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // home: const HomeView());
      home: const login_tree(),
    );
  }
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xffde5246, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffde5246), //10%
      100: Color(0xffe16359), //20%
      200: Color(0xffe5756b), //30%
      300: Color(0xffe8867e), //40%
      400: Color(0xffeb9790), //50%
      500: Color(0xffefa9a3), //60%
      600: Color(0xfff2bab5), //70%
      700: Color(0xfff5cbc8), //80%
      800: Color(0xfffceeed), //90%
      900: Color(0xffffffff), //100%
    },
  );
} // you can define define
// "AIzaSyBzCUkxMWFZ1Jz3sobOSkBoqH24T8pilcY"
