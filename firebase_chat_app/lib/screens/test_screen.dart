import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'package:firebase_chat_app/screens/home_page.dart';

class DataPage extends StatelessWidget {
  final String data;

  const DataPage({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.red[900], title: Text("Data Page")),
      body: Center(
          child: Text(data,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
    );
  }
}
