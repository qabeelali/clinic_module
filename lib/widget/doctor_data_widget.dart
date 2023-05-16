import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DoctorDataWidget extends StatelessWidget {
  const DoctorDataWidget(
      {super.key,
      required this.doctorName,
     this.specialty,
      required this.doctorId});
  final String doctorName;
  final String? specialty;
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.13,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 15,
                spreadRadius: 0.2,
                blurStyle: BlurStyle.outer,
                color: Color(0xff000000).withOpacity(0.2)),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Name: ${doctorName}',
              style: TextStyle(fontSize: 22, fontFamily: 'neo'),
            ),
            Container(
              height: 10,
            ),
            Text(
              'Specialty: ${specialty??''}',
              style: TextStyle(fontSize: 22, fontFamily: 'neo'),
            ),
            Container(
              height: 10,
            ),
            Text(
              'ID: ${doctorId}',
              style: TextStyle(fontSize: 22, fontFamily: 'neo'),
            ),
          ],
        ),
      ),
    );
  }
}
