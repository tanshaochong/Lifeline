import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final email;
  final String profileImageUrl;
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  ProfilePage(
      {super.key,
      required this.username,
      required this.email,
      required this.profileImageUrl});

  Widget ProfileButton(String buttonTitle) {
    return ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue.withOpacity(0.1)),
          child: const Icon(
            Icons.settings,
            color: Colors.blue,
          ),
        ),
        title: Text(buttonTitle),
        trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1)),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(height: 16.0),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                  onTap: () {
                    signOut();
                  },
                  child: ProfileButton('test'))
            ],
          ),
        ),
      ),
    );
  }
}
