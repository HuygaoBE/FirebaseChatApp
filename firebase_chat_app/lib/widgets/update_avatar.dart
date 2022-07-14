import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

class UpdateAvatar extends StatefulWidget {
  final String user;
  final String avatar;

  UpdateAvatar({required this.user, required this.avatar});

  @override
  _UpdateAvatarState createState() => _UpdateAvatarState();
}

class _UpdateAvatarState extends State<UpdateAvatar> {
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
        .doc(widget.user)
        .update({
      "image": '${imageUrl}',
    });

    // await FirebaseFirestore.instance
    //     .collection('post')
    //     //thay đổi vị trí, Upload message ở phía người nhắn
    //     .doc()
    //     .update({
    //   "avatar": '${imageUrl}',
    // });

    //---------------------------------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 10.0,
    //   width: 10.0,
    //   margin: const EdgeInsets.all(10.0),
    //   child: IconButton(
    //     icon: Icon(Icons.add_a_photo_sharp),
    //     onPressed: () {

    //     },
    //   ),
    // );
    // return MaterialButton(
    //   onPressed: () {},
    //   color: Colors.blue,
    //   child: const Icon(
    //     Icons.add_a_photo_sharp,
    //     size: 16.0,
    //   ),
    //   padding: const EdgeInsets.all(9.0),
    //   shape: const CircleBorder(),
    // );

    return Container(
      width: 37,
      height: 37,
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(
          side: BorderSide(
            width: 2.0,
            color: Colors.white,
          ),
        ),
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.add_a_photo_sharp,
            size: 16,
          ),
          onPressed: () async {
            await getImage();
          },
        ),
      ),
    );
  }
}
