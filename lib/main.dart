// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home View',
      home: HomeView(),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          fontFamily: 'Product Sans',
          scaffoldBackgroundColor: Color.fromARGB(255, 238, 240, 242)
          // ...add more customizations here
          ),
    );
  }
}
