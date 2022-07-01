import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirthdayDate extends StatefulWidget {
  final String user;
  final String birthdaydate;

  BirthdayDate({required this.user, required this.birthdaydate});
  @override
  _BirthdayDateState createState() => _BirthdayDateState();
}

class _BirthdayDateState extends State<BirthdayDate> {
  String? birthDateInString;
  DateTime? birthDate;
  bool isDateSelected = false;

  void _updateBirthdayDate(String date) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user)
        .update(
      {"birthdaydate": date},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.birthdaydate,
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        GestureDetector(
          child: const Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
          onTap: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
            if (datePick != null && datePick != birthDate) {
              setState(() {
                birthDate = datePick;
                isDateSelected = true;

                // put it here
                birthDateInString =
                    "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}";
                    _updateBirthdayDate(birthDateInString!);
              });
            }
          },
        ),
      ],
    );
  }
}
