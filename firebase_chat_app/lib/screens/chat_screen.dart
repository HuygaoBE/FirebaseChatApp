import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/widgets/message_textfield.dart';
import 'package:firebase_chat_app/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Tải message xuống và đẩy cho single_message phân loại message nào của mình, message nào của người khác
class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        // title: Row(
        //   children: [
        //     ClipRRect(
        //       borderRadius: BorderRadius.circular(80),
        //       child: CachedNetworkImage(
        //         imageUrl: friendImage,
        //         placeholder: (conteext, url) =>
        //             const CircularProgressIndicator(),
        //         errorWidget: (context, url, error) => const Icon(
        //           Icons.error,
        //         ),
        //         height: 40,
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomRight,
        //       child: Container(
        //         height: 13.0,
        //         width: 13.0,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: Colors.green,
        //           border: Border.all(color: Colors.red, width: 2.0),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 5,
        //     ),
        //     Text(
        //       friendName,
        //       style: const TextStyle(fontSize: 18.0),
        //     )
        //   ],
        // ),
        title: Row(
          children: [
            Stack(
              children: <Widget>[
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(80),
                //   child: CachedNetworkImage(
                //     imageUrl: friendImage,
                //     placeholder: (context, url) =>
                //         const CircularProgressIndicator(),
                //     errorWidget: (context, url, error) => const Icon(
                //       Icons.error,
                //     ),
                //     height: 40,
                //   ),
                // ),
                //Avatar Image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: NetworkImage(friendImage),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              friendName,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
                    .collection("users")
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text(
                          "Say Hi",
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
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            currentUser.uid;
                        return SingleMessage(
                          message: snapshot.data.docs[index]['message'],
                          messageImage: snapshot.data.docs[index]
                              ['messageImage'],
                          isMe: isMe,
                          datetime: snapshot.data.docs[index]['date']
                              .toDate()
                              .toString(),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          //TextFiel Chat client
          MessageTextField(currentUser.uid, friendId),
          //In ra data trạng thái của status user
          // _UserStatus(),
        ],
      ),
    );
  }

  // _UserStatus() {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     child: StreamBuilder<DocumentSnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(friendId)
  //           .snapshots(),
  //       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Text('Loading UserStatus');
  //         }
  //         var userStatus = snapshot.data;
  //         print(
  //             'KQ------------------: FriendId:${friendId} ------type Status: ${(snapshot.data!['status']).runtimeType}');
  //         return Text(snapshot.data!['status']);
  //       },
  //     ),
  //   );
  // }
}
