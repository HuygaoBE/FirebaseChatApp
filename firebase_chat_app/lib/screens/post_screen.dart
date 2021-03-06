import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/widgets/post_show.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/single_post.dart';

class PostScreen extends StatefulWidget {
  UserModel user;
  PostScreen(this.user);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  void _avatarRoot(String avt) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(avt)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      // if (documentSnapshot.exists) {
        // print('Document data: ${documentSnapshot.get('image')}');
      // } else {
      //   print('Document does not exist on the database');
      // }
      // return documentSnapshot.get('image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("post")
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text(
                          "Hãy đăng tin của bạn",
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // return SingleMessage(
                        //   message: snapshot.data.docs[index]['message'],
                        //   messageImage: snapshot.data.docs[index]
                        //       ['messageImage'],
                        //   isMe: isMe,
                        //   datetime: snapshot.data.docs[index]['date']
                        //       .toDate()
                        //       .toString(),
                        // );
                        _avatarRoot(snapshot.data.docs[index]['uid']);

                        return PostShow(
                          user: widget.user,
                          avatar: snapshot.data.docs[index]['avatar'],
                          name: snapshot.data.docs[index]['name'],
                          postID: snapshot.data.docs[index]['postid'],
                          uid: snapshot.data.docs[index]['uid'],
                          imagePost: snapshot.data.docs[index]['image'],
                          content: snapshot.data.docs[index]['content'],
                          datetime: snapshot.data.docs[index]['date'],
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          //Button Post-------------------------------
          Container(
            // height: 290,
            // width: 450,
            padding: const EdgeInsets.only(
              // left: 290,
              // top: 0,
              // right: 20,
              // bottom: 200,
              // right: 1,
              bottom: 80,
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SinglePost(
                      user: widget.user,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.create),
              label: const Text('Post'),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: FloatingActionButton.extended(
      //   onPressed: () {},
      //   icon: const Icon(Icons.save),
      //   label: const Text("halo"),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      // floatingActionButton: Positioned(
      //   // width: 200.0,
      //   // height: 200.0,
      //   right: 20.0,
      //   top: 1,
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //     child: const Icon(Icons.create),
      //   ),
      // ),
    );
  }
}
