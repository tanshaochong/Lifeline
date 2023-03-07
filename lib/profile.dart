import 'package:flutter/material.dart';
import 'home.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;

  ProfilePage(
      {required this.username,
      required this.email,
      required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(height: 16.0),
            Text(
              username,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              email,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
