import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/widgets/single_postshow.dart';
import 'package:flutter/material.dart';

class PostShow extends StatefulWidget {
  final UserModel user;
  final String name;
  final String avatar;
  final String postID;
  final String uid;
  final String imagePost;
  final String content;
  final Timestamp datetime;

  PostShow(
      {required this.user,
      required this.name,
      required this.avatar,
      required this.postID,
      required this.uid,
      required this.imagePost,
      required this.content,
      required this.datetime});

  @override
  _PostShowState createState() => _PostShowState();
}

class _PostShowState extends State<PostShow> {

  // void initState() {
  //   super.initState();
  //   _avatarRoot();
  // }

  //---------------------------------------------

  //-----------------------------------------------

  // void _avatarRoot() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     // if (documentSnapshot.exists) {
  //     //   print('Document data: ${documentSnapshot.get('image')}');
  //     // } else {
  //     //   print('Document does not exist on the database');
  //     // }
  //     LinkImage(documentSnapshot.get('image'));
  //   });
  // }

  // String LinkImage(String avt) {
  //   print('AVT-------------------------: ${avt}');
  //   return avt;
  // }


//--------------------------------------------------------

  // String LinkAvatar(String scr) {
  //   var temp = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     // if (documentSnapshot.exists) {
  //     //   print('Document data: ${documentSnapshot.get('image')}');
  //     // } else {
  //     //   print('Document does not exist on the database');
  //     // }
  //     documentSnapshot.get('image');
  //   });
  //   return temp;
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                //Avatar User Post
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: NetworkImage(widget.avatar),
                    // backgroundImage: NetworkImage(LinkAvatar(widget.uid)),
                  ),
                ),
                //Name User and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Name User Post
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Show Date Post Edit ------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        '${(widget.datetime).toDate()}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      //Show Date format Day----------------------
                      // child: PostTime(date: widget.date),
                    ),
                  ],
                ),
                // const SizedBox(
                //   width: 100.0,
                // ),
                //Post Delete and Update---------------------------
                widget.user.uid == widget.uid
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          alignment: Alignment.topRight,
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SinglePostShow(
                                  user: widget.user,
                                  postID: widget.postID,
                                  content: widget.content,
                                  image: widget.imagePost,
                                  date: widget.datetime,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
            //Line
            const Divider(
              height: 5.0,
              color: Colors.black,
            ),
            //Post Content
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10.0, 4.0, 10.0),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                maxLines: 3,
              ),
            ),
            //Post Image
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
              child: Image.network('${widget.imagePost}'),
            ),
          ],
        ),
      ),
    );
  }
}
