// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class UploadImage extends StatelessWidget {
//   File? imageFile;
//   Future getImage() async {
//     ImagePicker _picker = ImagePicker();
//     await _picker.pickImage(source: ImageSource.gallery).then((XFile) {
//       if (XFile != null) {
//         imageFile = File(XFile.path);
//         uploadImage();
//       }
//     });
//   }

//   Future uploadImage() async {
//     String fileName = Uuid().v1();

//     var ref =
//         FirebaseStorage.instance.ref().child('images').child('${fileName}.jpg');

//     var uploadTask = await ref.putFile(imageFile!);

//     String imageUrl = await uploadTask.ref.getDownloadURL();
//     print('imageUrl-----------------------: ${imageUrl}');
//   }

//   // @override
//   // Widget build(BuildContext context) {}
// }
