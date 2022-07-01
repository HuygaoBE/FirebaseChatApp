import 'package:flutter/material.dart';
import 'package:firebase_chat_app/widgets/single_message.dart';

class ShowImage extends StatelessWidget {
  final String imageUrl;
  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(
          '${imageUrl}',
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Text('ð¢');
          },
        ),
      ),
    );
  }
}
