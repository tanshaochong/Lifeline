import 'auth.dart';
import 'home.dart';
import 'login_register_page.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class login_tree extends StatefulWidget {
  const login_tree({Key? key}) : super(key: key);

  @override
  State<login_tree> createState() => _LoginTreeState();
}

class _LoginTreeState extends State<login_tree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeView();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
