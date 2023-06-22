import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PatientDataWidget extends StatefulWidget {
   PatientDataWidget({super.key, required this.patientName, required this.gender, required this.age, required this.sheetId,  this.weight, required this.date, required this.edit});
  final String patientName;
  final String gender;
  final String age;
  final String sheetId;
  final String? weight;
  final String date;
  final bool edit;

  @override
  State<PatientDataWidget> createState() => _PatientDataWidgetState();
}

class _PatientDataWidgetState extends State<PatientDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.18,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 15,
                spreadRadius: 0.2,
                blurStyle: BlurStyle.outer,
                color: Color(0xff000000).withOpacity(0.2)),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Name: ${widget.patientName}',
              style: TextStyle(fontSize: 22, fontFamily: 'neo'),
            ),
            Container(height:  MediaQuery.of(context).size.height * 0.01,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gender: ${widget.gender}',
                  style: TextStyle(fontSize: 22, fontFamily: 'neo'),
                ),
                Container(
                    width:MediaQuery.of(context).size.width*0.3 ,
                  child: Text(
                    'Age: ${widget.age}',
                    style: TextStyle(fontSize: 22, fontFamily: 'neo'),
                  ),
                )
              ],
            ),
            Container(height:  MediaQuery.of(context).size.height * 0.01,),
           
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${widget.sheetId}',
                  style: TextStyle(fontSize: 22, fontFamily: 'neo'),
                ),
                Container(
                  width:MediaQuery.of(context).size.width*0.3 ,
                  child: Text(
                    'Weight: ${widget.weight??''}',
                    
                    style: TextStyle(fontSize: 22, fontFamily: 'neo', ),
                  ),
                ),

              ],
            ),
            Container(height:  MediaQuery.of(context).size.height * 0.01,),
              Text(
                  'Date: ${widget.date}',
                  style: TextStyle(fontSize: 22, fontFamily: 'neo'),
                ),
          ],
        ),
      ),
    );
  }
}
