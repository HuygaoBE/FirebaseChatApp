import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String name;
  String addressname;
  String image;
  String backgroundimage;
  Timestamp date;
  String birthdaydate;
  String uid;

  UserModel(
      {required this.email,
      required this.name,
      required this.addressname,
      required this.image,
      required this.backgroundimage,
      required this.date,
      required this.birthdaydate,
      required this.uid,});

  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    return UserModel(
      email: snapshot['email'],
      name: snapshot['name'],
      addressname: snapshot['addressname'],
      image: snapshot['image'],
      backgroundimage: snapshot['backgroundimage'],
      date: snapshot['date'],
      birthdaydate: snapshot['birthdaydate'],
      uid: snapshot['uid'],
    );
  }
}
