import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

import '../models/user_model.dart';

class SinglePost extends StatefulWidget {
  final UserModel user;

  SinglePost({required this.user});

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
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

    var postID = await FirebaseFirestore.instance
        .collection('post')
        //thay đổi vị trí, Upload message ở phía người nhắn
        .add({
      "uid": widget.user.uid,
      "content": '${writingTextController.text}',
      "date": DateTime.now(),
      "image": '${imageUrl}',
      "postid": '',
      "name": widget.user.name,
      "avatar": widget.user.image,
    });

    //update key document post
    await FirebaseFirestore.instance
        .collection('post')
        .doc(postID.id)
        .update({
          "postid": postID.id,
    });
  }

//------------------------------------------------------------------------------------------
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //   );
  // }
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

  void _postToFB() async {
    setState(() {
      _isLoading = true;
    });
    // String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if (imageFile != null) {
      // postImageURL = await FBStorage.uploadPostImages(postID: postID, postImageFile: _postImageFile);
      uploadImage();
    }
    // FBCloudStore.sendPostInFirebase(postID,writingTextController.text,widget.myData,postImageURL ?? 'NONE');
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     //thay đổi vị trí, Upload message ở phía người nhắn
    //     .doc(widget.user.uid)
    //     .collection('post')
    //     .add({
    //   "uid": widget.user.uid,
    //   "date": DateTime.now(),
    //   "image": '${imageUrl}',
    // });

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tạo bài viết'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () => _postToFB(),
              child: const Text(
                'Đăng',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
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
                    height: size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        80,
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
                                // child: Container(
                                //     width: 40,
                                //     height: 40,
                                //     child:
                                //         Image.network('${widget.user.image}')),
                                // child: ClipRRect(
                                //   borderRadius: BorderRadius.circular(80),
                                //   child: CachedNetworkImage(
                                //     imageUrl: widget.user.image,
                                //     placeholder: (context, url) =>
                                //         const CircularProgressIndicator(),
                                //     errorWidget: (context, url, error) =>
                                //         const Icon(
                                //       Icons.error,
                                //     ),
                                //     height: 40,
                                //     width: 40,
                                //   ),
                                // ),
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      NetworkImage(widget.user.image),
                                ),
                              ),
                              Text(
                                widget.user.name,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          TextFormField(
                            autofocus: true,
                            focusNode: writingTextFocus,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Hãy viết gì đó...',
                              hintMaxLines: 4,
                            ),
                            controller: writingTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          //Show image
                          imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
