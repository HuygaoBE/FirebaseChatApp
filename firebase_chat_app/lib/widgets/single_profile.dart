import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widgets/birthday_date.dart';
import 'package:firebase_chat_app/widgets/update_avatar.dart';
import 'package:firebase_chat_app/widgets/update_background.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/auth_screen.dart';

//Build Widget Profile Screen
class SingleProfile extends StatelessWidget {
  final String backgroundImage;
  final String avatarImage;
  final String name;
  final String email;
  final String useruid;
  final String birthdaydate;

  SingleProfile(
      {required this.backgroundImage,
      required this.avatarImage,
      required this.name,
      required this.email,
      required this.useruid,
      required this.birthdaydate});

  final double backgroundHeight = 280.0;
  final double avatarHeight = 144.0;

  @override
  Widget build(BuildContext context) {
    final double topAvatar = backgroundHeight - (avatarHeight / 2);
    final double bottomAvatar = avatarHeight / 2;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: bottomAvatar),
                color: Colors.grey,
                //get address background image
                child: Image.network(
                  backgroundImage,
                  width: double.infinity,
                  height: backgroundHeight,
                  fit: BoxFit.cover,
                ),
              ),
              //Update Background Avatar
              Positioned(
                right: 0.0,
                bottom: 75.0,
                child: UpdateBackground(user: useruid),
              ),
              Positioned(
                top: topAvatar,
                child: CircleAvatar(
                  radius: avatarHeight / 2,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: NetworkImage(avatarImage),
                ),
              ),
              //Update Avatar
              Positioned(
                right: 125.0,
                bottom: 0.0,
                child: UpdateAvatar(
                  user: useruid,
                  avatar: '',
                ),
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Text(
                '${name}',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                'Email: ${email}',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black26,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              //Show Birthday Date
              BirthdayDate(user: useruid, birthdaydate: birthdaydate),
              //Logout Account
              const SizedBox(
                height: 150.0,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text('Thoát'),
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                      (route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
