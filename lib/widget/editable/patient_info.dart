import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../controller/ptient_controller.dart';
import '../../model/sheet.dart';

class PatientInfoEditable extends StatefulWidget {
  PatientInfoEditable({super.key, this.userInfo});
  UserInfo? userInfo;

  @override
  State<PatientInfoEditable> createState() => _PatientInfoEditableState();
}

class _PatientInfoEditableState extends State<PatientInfoEditable> {
  String gender = 'male';
  @override
  Widget build(BuildContext context) {
    SheetToSend sheet =
        Provider.of<PatientController>(context, listen: false).sheetToSend!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.98,
      height: MediaQuery.of(context).size.height * 0.23,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(35),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Patient Name:',
                      style: TextStyle(fontSize: 20, fontFamily: 'neo')),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      child: TextField(
                        onChanged:
                            Provider.of<PatientController>(context).changeName,
                        decoration: InputDecoration(
                            hintText: widget.userInfo == null
                                ? 'Patient Name'
                                : widget.userInfo!.patient_name),
                      ),
                      width: MediaQuery.of(context).size.width * 0.54)
                ],
              ),
              Row(
                children: [
                  Text('Gender:',
                      style: TextStyle(fontSize: 20, fontFamily: 'neo')),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: DropdownButton(
                        value: gender,
                        items: [
                          DropdownMenuItem(
                            child: Text('female'),
                            value: 'female',
                          ),
                          DropdownMenuItem(
                            child: Text('male'),
                            value: 'male',
                          )
                        ],
                        onChanged: (e) {
                          if (e == 'male') {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .changeGender(0);
                          } else {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .changeGender(1);
                          }
                          setState(() {
                            gender = e!;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Age:',
                      style: TextStyle(fontSize: 20, fontFamily: 'neo')),
                  Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Container(
                          child: TextField(
                            onChanged: Provider.of<PatientController>(context,
                                    listen: false)
                                .changeAge,
                            decoration: InputDecoration(
                                hintText: widget.userInfo == null
                                    ? '20y'
                                    : widget.userInfo!.age),
                          ),
                          width: MediaQuery.of(context).size.width * 0.25))
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Weight:',
                      style: TextStyle(fontSize: 20, fontFamily: 'neo')),
                  Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Container(
                          child: TextField(
                            onChanged: Provider.of<PatientController>(context,
                                    listen: false)
                                .changeWeight,
                            decoration: InputDecoration(
                                hintText: widget.userInfo == null
                                    ? '70kg'
                                    : widget.userInfo!.weight),
                          ),
                          width: MediaQuery.of(context).size.width * 0.25)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
