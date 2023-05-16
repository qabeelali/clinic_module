import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_nps/widget/patient_data_widget.dart';
import 'package:provider/provider.dart';

import '../controller/pahrmacy_controller.dart';
import '../model/pharmacy_model.dart';

class PharmacyAppBar extends StatelessWidget {
  const PharmacyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Recieved? recieved = Provider.of<PharmacyController>(context).received;

    return Flexible(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.189,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff189FE8), Color(0xff006CA7)]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back_ios_new),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Patient',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'neo',
                                fontSize: 20),
                          ),
                          Container(
                            width: 30,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                PatientDataWidget(
                    patientName: '${recieved!.user_info.patient_name}',
                    gender: '${recieved!.user_info.gender}',
                    age: '${recieved!.user_info.age}',
                    sheetId: '${recieved!.id}',
                    date: '${recieved!.date}',
                    edit: false)
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 -
                (MediaQuery.of(context).size.width * 0.9 / 2),
            top: MediaQuery.of(context).size.height * 0.13,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Material(
                borderRadius: BorderRadius.circular(14),
                // elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doctor Name: ${recieved!.doctor.full_name}',
                        style: TextStyle(fontFamily: 'neo', fontSize: 22),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        'Speciality:${recieved!.doctor.bio ?? ''}',
                        style: TextStyle(fontFamily: 'neo', fontSize: 22),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        'ID:${recieved!.doctor.id}',
                        style: TextStyle(fontFamily: 'neo', fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
