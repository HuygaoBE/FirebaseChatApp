import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

//Upload message vào chung document của colection cua chats trong đó lưu
//2 document của 2 users lưu trong collection senderId và reveiverId
class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  MessageTextField(this.currentId, this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  //@override Thực thi hàm initState của lớp cha State lớp cha của lớp _MyHomePageState
  void initState() {
    super.initState();
  }

  int printValue(int value) {
    return value;
  }

  @override
  // Hàm dispose Khi thẻ bị hủy thì nó được gọi đến
  void dispose() {
    super.dispose();
  }

//-----------------------------------------------------------------------------
//In xem data trang thai status
  // void getUserStatus() async {
  //   var status;
  //   status = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.currentId)
  //       .collection('status')
  //       .snapshots();
  //   print('STATUS-----xx--------------${status}');
  // }
//------------------------------------------------------------------------

  File? imageFile;
  Future getImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((XFile) {
      if (XFile != null) {
        imageFile = File(XFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();

    var ref =
        FirebaseStorage.instance.ref().child('images').child('${fileName}.jpg');

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {});

    String imageUrl = await uploadTask.ref.getDownloadURL();
    print('imageUrl-----------------------: ${imageUrl}');

    //---------------------------------------------------------------------

    await FirebaseFirestore.instance
        .collection('users')
        //thay đổi vị trí, Upload message ở phía người nhắn
        .doc(widget.currentId)
        .collection('messages')
        //thay đổi vị trí
        .doc(widget.friendId)
        .collection('chats')
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": "",
      "type": "text",
      "date": DateTime.now(),
      "messageImage": '${imageUrl}',
    });

    await FirebaseFirestore.instance
        .collection('users')
        //Thay đổi vị trí, upload đường dẫn cho người nhận message
        .doc(widget.friendId)
        .collection('messages')
        //Thay đổi vị trí
        .doc(widget.currentId)
        .collection("chats")
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": "",
      "type": "text",
      "date": DateTime.now(),
      "messageImage": '${imageUrl}',
    });

    //---------------------------------------------------------------------
  }

//-----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Type your Message",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 200),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    getImage();
                    // setState(() {
                    //   getImage();
                    // });
                  },
                  icon: const Icon(
                    Icons.photo,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              //Nếu để trống thì không thể chat và gửi message lên Firebase được
              if (message.isEmpty) {
                return _controller.clear();
              } else {
                await FirebaseFirestore.instance
                    .collection('users')
                    //thay đổi vị trí, Upload message ở phía người nhắn
                    .doc(widget.currentId)
                    .collection('messages')
                    //thay đổi vị trí
                    .doc(widget.friendId)
                    .collection('chats')
                    .add({
                  "senderId": widget.currentId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now(),
                  "messageImage": '',
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('users')
                      //Thay đổi vị trí
                      .doc(widget.currentId)
                      .collection('messages')
                      //Thay đổi vị trí
                      .doc(widget.friendId)
                      .set({
                    'last_msg': message,
                  });
                });

                await FirebaseFirestore.instance
                    .collection('users')
                    //Thay đổi vị trí, upload đường dẫn cho người nhận message
                    .doc(widget.friendId)
                    .collection('messages')
                    //Thay đổi vị trí
                    .doc(widget.currentId)
                    .collection("chats")
                    .add({
                  "senderId": widget.currentId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now(),
                  "messageImage": '',
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('users')
                      //Thay đổi vị trí
                      .doc(widget.friendId)
                      .collection('messages')
                      //Thay đổi vị trí
                      .doc(widget.currentId)
                      .set({"last_msg": message});
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
