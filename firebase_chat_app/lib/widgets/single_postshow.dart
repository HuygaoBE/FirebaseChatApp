import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/widgets/post_show.dart';
import 'package:firebase_chat_app/widgets/post_time.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

import '../models/user_model.dart';

class SinglePostShow extends StatefulWidget {
  UserModel user;
  final String postID;
  final String content;
  final String image;
  final Timestamp date;

  SinglePostShow(
      {required this.user,
      required this.postID,
      required this.content,
      required this.image,
      required this.date});

  @override
  _SinglePostShowState createState() => _SinglePostShowState();
}

class _SinglePostShowState extends State<SinglePostShow> {
  @override
  //@override Thực thi hàm initState của lớp cha State lớp cha của lớp _MyHomePageState
  void initState() {
    super.initState();
    writingTextController.text = widget.content;
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
        // uploadImage();
        setState(() {
          _buildConfig(context);
        });
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

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     //thay đổi vị trí, Upload message ở phía người nhắn
    //     .doc(widget.user.uid)
    //     .update({
    //       "image": '${imageUrl}',
    //     });

    //update key document post
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postID)
        .update({
      "content": writingTextController.text,
      "date": DateTime.now(),
      "image": imageUrl,
    });
  }

//------------------------------------------------------------------------------------------
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //   );
  // }
  final _fromKey = GlobalKey<FormState>();
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  // File _postImageFile;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                // onTap: () {
                //   print('Select Image');
                //   // _getImageAndCrop();
                //   getImage();
                // },
                onTap: () {
                  setState(() {
                    getImage();
                  });
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        "Thêm ảnh",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  void _createPost() async {
    setState(() {
      _isLoading = true;
    });
    String postImageURL;
    if (imageFile != null) {
      uploadImage();
    }
    //Only update content, No update image post
    else {
      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postID)
          .update({
        "content": writingTextController.text,
        "date": DateTime.now(),
      });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

//-----------------------------------Delete Post------------------------------
  void _deletePost() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postID)
        .delete();
    setState(() {
      //comeback Post Screen
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sửa bài viết'),
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () => _deletePost(),
                child: const Text(
                  'Xóa',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => _createPost(),
                child: const Text(
                  'Đăng',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(

                    width: size.width,
                    // height: size.height -
                    //     MediaQuery.of(context).viewInsets.bottom -
                    //     20,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //Avatar Image
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      NetworkImage(widget.user.image),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    widget.user.name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Show Date Post Edit ------------------------------------------------------
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '${(widget.date).toDate()}',
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
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          //Input content Post-----------------------------------
                          Form(
                            key: _fromKey,
                            child: TextFormField(
                              autofocus: true,
                              focusNode: writingTextFocus,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Hãy viết gì đó.',
                                hintMaxLines: 4,
                              ),
                              controller:
                                  // (writingTextController.text).length == null ?
                                  // (widget.content) :
                                  writingTextController,
                              // onChanged: (value) {
                              //   if (value.isEmpty) {
                              //       setState(() {
                              //         writingTextController.text = widget.content;
                              //       });
                              //   }
                              // },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                          //Show image-------------------------------
                          imageFile == null
                              ? Image.network(
                                  widget.image,
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  imageFile!,
                                  fit: BoxFit.fill,
                                ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          // const Center(child: CircularProgressIndicator()),
          // Utils.loadingCircle(_isLoading),
        ],
      ),
    );
  }
}
