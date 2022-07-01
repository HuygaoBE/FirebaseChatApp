import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/widgets/single_profile.dart';
import 'package:flutter/material.dart';

class ProflieScreen extends StatefulWidget {
  UserModel user;
  ProflieScreen(this.user);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProflieScreen> {
  @override
  Widget build(BuildContext context) {
    return _readFirebaseUser();
  }

  _readFirebaseUser() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleProfile(
              backgroundImage: snapshot.data['backgroundimage'],
              avatarImage: snapshot.data['image'],
              name: snapshot.data['name'],
              email: snapshot.data['email'],
              useruid: snapshot.data['uid'],
              birthdaydate: snapshot.data['birthdaydate']
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _backgroundImage(String img) {
    return Container(
      color: Colors.grey,
      child: Image.network(
        '${img}',
        width: double.infinity,
        height: 280.0,
        fit: BoxFit.cover,
      ),
    );
  }

  _AvatarImage(String img) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage('${img}'),
    );
  }
}
