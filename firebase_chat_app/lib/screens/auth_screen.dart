import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/screens/home_page.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
//---------------------------------------------------------
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();

    controller =
        // Hiệu ứng chuyển background color
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
  }

  String RandomString(int strlen) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }


  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

//----------------------------------------------------------
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    if (userExist.exists) {
      print("User Already Exists in Database");
    } else {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'addressname': RandomString(12),
        'image': userCredential.user!.photoURL,
        'backgroundimage': 'https://firebasestorage.googleapis.com/v0/b/fir-chat-app-ab6ae.appspot.com/o/backgroundimage%2Fcat.jpg?alt=media&token=05df4214-0638-44f0-95c4-50abdfa691b5',
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
        'birthdaydate': 'Chưa có'
      });
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                child: Icon(
                  Icons.people,
                  color: Colors.amber,
                ),
                height: 80.0,
              ),
            ),
            SizedBox(
              width: 300.0,
              height: 100.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 35.0,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    RotateAnimatedText('CHAT ENGINE'),
                    RotateAnimatedText('HÃY THỬ'),
                    RotateAnimatedText('VÀ TRẢI NGHIỆM'),
                  ],
                  onTap: () {
                    print('onTap Chat Engine');
                  },
                ),
              ),
            ),
            const Text(
              "Chat App",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ElevatedButton(
                onPressed: () async {
                  await signInFunction();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                      height: 36,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Login Google",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 12))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
