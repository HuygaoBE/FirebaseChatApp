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
  // const HomePage({Key? key}) : super(key: key);
  UserModel user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

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

  // @override
  // Widget build(BuildContext context) {
  //   //----------------------------
  //   return Scaffold(
  //       bottomNavigationBar: CurvedNavigationBar(
  //         key: _bottomNavigationKey,
  //         index: 0,
  //         height: 60.0,
  //         items: const <Widget>[
  //           Icon(Icons.cottage, size: 30),
  //           Icon(Icons.person_search, size: 30),
  //           Icon(Icons.chat, size: 30),
  //           Icon(Icons.perm_identity, size: 30),
  //         ],
  //         color: Colors.white,
  //         buttonBackgroundColor: Colors.white,
  //         backgroundColor: Colors.blueAccent,
  //         animationCurve: Curves.easeInOut,
  //         animationDuration: const Duration(milliseconds: 600),
  //         onTap: (index) {
  //           setState(() {
  //             _page = index;
  //             // screens[index];
  //           });
  //         },
  //         letIndexChange: (index) => true,
  //       ),
  //       body: screens[_page]
  //       // body: Container(
  //       //   color: Colors.blueAccent,
  //       //   child: Center(
  //       //     child: Column(
  //       //       mainAxisAlignment: MainAxisAlignment.center,
  //       //       children: <Widget>[
  //       //         Text(_page.toString(), textScaleFactor: 10.0),
  //       //         ElevatedButton(
  //       //           child: const Text('Go To Page of index 1'),
  //       //           onPressed: () {
  //       //             final CurvedNavigationBarState? navBarState =
  //       //                 _bottomNavigationKey.currentState;
  //       //             navBarState?.setPage(3);
  //       //           },
  //       //         )
  //       //       ],
  //       //     ),
  //       //   ),
  //       // ),
  //       );
  // }
  GlobalKey _NavKey = GlobalKey();

  //-------------------------------------------
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void PushHomeScreen() {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
  // }

  // var PagesAll = [
  //   nextScreen(),
  //   TestScreen(userModel),
  //   // TestScreen('home!'),
  //   // TestScreen('home!'),
  //   // TestScreen('home!')
  // ];

  var myindex = 0;
  //-----------------------------------------------------------------------------
  // int _currIndex = 0;
  // _onTap(int index) {
  //   setState(() => _currIndex = index);
  //   switch (index) {
  //     case 0:
  //       Navigator.of(context)
  //           .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //         return new DataPage(data: 'Home');
  //       }));
  //       break;
  //     case 1:
  //       Navigator.of(context)
  //           .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //         return new DataPage(data: 'Favorite');
  //       }));
  //       break;
  //     case 2:
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
  //       break;
  //     case 3:
  //       Navigator.of(context)
  //           .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //         return new DataPage(data: 'Settings');
  //       }));
  //       break;
  //     default:
  //       Navigator.of(context)
  //           .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //         return new DataPage(data: 'Home');
  //       }));
  //   }
  // }

  //----------------------------------------------------------------------------

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
