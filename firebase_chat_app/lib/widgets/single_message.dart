import 'package:firebase_chat_app/screens/showimage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:firebase_chat_app/screens/showimage.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final String datetime;
  final String messageImage;
  SingleMessage({
    required this.message,
    required this.isMe,
    required this.datetime,
    required this.messageImage,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: messageImage.isNotEmpty
            ? [
                Container(
                  //
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(45.0),
                    ),
                  ),
                  child: InkWell(
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    ShowImage(imageUrl: '${messageImage}')),
                          ),
                      // child: Container(
                      //   height: size.height / 2.5,
                      //   width: size.width / 2.0,
                      //   alignment: Alignment.center,
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(25.0),
                      //     ),
                      //   ),
                      //   child: Image.network(
                      //     '${messageImage}',
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      //-------------
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   child: Image.network(
                      //     '${messageImage}',
                      //     height: size.height / 2.5,
                      //     width: size.width / 2.0,
                      //   ),
                      // ),
                      //----------------------------
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(110.0), // Image radius
                          child: Image.network(
                            '${messageImage}',
                            fit: BoxFit.cover,
                            //Bắt lỗi ảnh không downloading
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Text('ð¢');
                            },
                          ),
                        ),
                      )),
                )
              ]
            : [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(10),
                  constraints: BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    // color: isMe ?
                    color: isMe ? Colors.blue : Colors.orange,
                    // borderRadius: BorderRadius.all(Radius.circular(12))),
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                            bottomRight: Radius.circular(3.0),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(3.0),
                            topRight: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                          ),
                  ),
                  // child: Text(
                  //   message,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 17.0,
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        datetime,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 9.0,
                        ),
                      )
                    ],
                  ),
                ),
              ]
        // children: [
        //   // Container(
        //   //   padding: EdgeInsets.all(16),
        //   //   margin: EdgeInsets.all(16),
        //   //   constraints: BoxConstraints(maxWidth: 200),
        //   //   decoration: BoxDecoration(
        //   //     // color: isMe ?
        //   //     color: isMe ? Colors.blue : Colors.orange,
        //   //     // borderRadius: BorderRadius.all(Radius.circular(12))),
        //   //     borderRadius: isMe
        //   //         ? const BorderRadius.only(
        //   //             topLeft: Radius.circular(18.0),
        //   //             topRight: Radius.circular(18.0),
        //   //             bottomLeft: Radius.circular(18.0),
        //   //             bottomRight: Radius.circular(3.0),
        //   //           )
        //   //         : const BorderRadius.only(
        //   //             topLeft: Radius.circular(18.0),
        //   //             topRight: Radius.circular(18.0),
        //   //             bottomLeft: Radius.circular(3.0),
        //   //             bottomRight: Radius.circular(18.0),
        //   //           ),
        //   //   ),
        //   //   child: Text(
        //   //     message,
        //   //     style: const TextStyle(
        //   //       color: Colors.white,
        //   //       fontSize: 17.0,
        //   //     ),
        //   //   ),
        //   // ),
        //   // Text(
        //   //   datetime,
        //   // ),
        //   //-------------------
        //   Container(
        //     height: 100.0,
        //     width: 70.0,
        //     alignment: Alignment.center,
        //     child: messageImage.isEmpty
        //         ? Text('Ko có ảnh')
        //         : Image.network(messageImage),
        //   ),
        //   //---------------------------------------------
        //   Container(
        //     padding: const EdgeInsets.all(16.0),
        //     margin: EdgeInsets.all(10),
        //     constraints: BoxConstraints(maxWidth: 200),
        //     decoration: BoxDecoration(
        //       // color: isMe ?
        //       color: isMe ? Colors.blue : Colors.orange,
        //       // borderRadius: BorderRadius.all(Radius.circular(12))),
        //       borderRadius: isMe
        //           ? const BorderRadius.only(
        //               topLeft: Radius.circular(18.0),
        //               topRight: Radius.circular(18.0),
        //               bottomLeft: Radius.circular(18.0),
        //               bottomRight: Radius.circular(3.0),
        //             )
        //           : const BorderRadius.only(
        //               topLeft: Radius.circular(18.0),
        //               topRight: Radius.circular(18.0),
        //               bottomLeft: Radius.circular(3.0),
        //               bottomRight: Radius.circular(18.0),
        //             ),
        //     ),
        //     // child: Text(
        //     //   message,
        //     //   style: const TextStyle(
        //     //     color: Colors.white,
        //     //     fontSize: 17.0,
        //     //   ),
        //     // ),
        //     child: Column(
        //       children: [
        //         Text(
        //           message,
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontSize: 17.0,
        //           ),
        //         ),
        //         Text(
        //           datetime,
        //           style: const TextStyle(
        //             color: Colors.black,
        //             fontSize: 9.0,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ],
        );
  }
}
