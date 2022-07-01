import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/screens/auth_screen.dart';
import 'package:firebase_chat_app/screens/chat_screen.dart';
import 'package:firebase_chat_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  //@override Thực thi hàm initState của lớp cha State lớp cha của lớp _MyHomePageState
  void initState() {
    super.initState();
  }

  @override
  // Hàm dispose Khi thẻ bị hủy thì nó được gọi đến
  void dispose() {
    super.dispose();
  }

//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return const Center(
                child: Text("Không tìm thấy!"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        var friend = asyncSnapshot.data;
                        return ListTile(
                          leading: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      NetworkImage(friend['image']),
                                ),
                              ),
                            ],
                          ),
                          title: Text(friend['name']),
                          subtitle: Container(
                            child: Text(
                              "$lastMsg",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        currentUser: widget.user,
                                        friendId: friend['uid'],
                                        friendName: friend['name'],
                                        friendImage: friend['image'])));
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
