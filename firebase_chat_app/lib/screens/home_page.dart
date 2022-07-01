import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/screens/auth_screen.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/screens/post_screen.dart';
import 'package:firebase_chat_app/screens/profile_screen.dart';
import 'package:firebase_chat_app/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_chat_app/screens/test_screen.dart';
import 'package:firebase_chat_app/screens/test_screen.dart';

class HomePage extends StatefulWidget {
  UserModel user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<Widget> nextPage(UserModel userModel) async {
    return HomeScreen(userModel);
  }

  //Trỏ đường dẫn tới Screen khác của thanh điều hướng CurvedNavigationBar
  Widget nextScreen(int index) {
    // setState(() => _currIndex = index);
    switch (index) {
      case 0:
        return PostScreen(widget.user);
      case 1:
        return SearchScreen(widget.user);
      case 2:
        return HomeScreen(widget.user);
      default:
        return ProflieScreen(widget.user);
    }
  }

  GlobalKey _NavKey = GlobalKey();


  var myindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        key: _NavKey,
        items: [
          Icon(
            (myindex == 0) ? Icons.home_outlined : Icons.home,
            color: Colors.red,
          ),
          Icon((myindex == 1) ? Icons.search_outlined : Icons.search),
          Icon((myindex == 2) ? Icons.message : Icons.message_outlined),
          Icon((myindex == 3)
              ? Icons.perm_identity
              : Icons.perm_contact_cal_rounded)
        ],
        buttonBackgroundColor: Color.fromARGB(255, 251, 196, 157),
        onTap: (index) {
          setState(() {
            myindex = index;
          });
        },
        // onTap: _onTap,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        color: Colors.orange,
      ),
      // body: PagesAll[myindex],
      // body: HomeScreen(widget.user),
      body: nextScreen(myindex),
    );
  }
}
