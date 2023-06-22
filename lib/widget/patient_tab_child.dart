import '../controller/provider.dart';
import '../controller/ptient_controller.dart';
import '../model/sheet.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class PatientTabChild extends StatelessWidget {
  const PatientTabChild({
    super.key,
    required this.data,
  });
  final Sheet data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Provider.of<provider>(context).isPatientWidgetClicable
          ? () {
              Provider.of<PatientController>(context, listen: false)
                  .getShowSheet(data.update_id.toString());
              Navigator.of(context).pushNamed('/patient').then((value) {
                Provider.of<PatientController>(context, listen: false)
                    .getSheets();
              });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Material(
                  borderRadius: BorderRadius.circular(24),
                  elevation: 1,
                  child: Container(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? null
                        : MediaQuery.of(context).size.height * 0.17,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.81,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Patient Name: ${data.patient_name}",
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'neo',
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.aspectRatio >=
                                      0.6
                                  ? 0.0
                                  : MediaQuery.of(context).size.height * 0.025),
                          child: Text(
                            "Gander: ${data.gender}",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'neo',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.aspectRatio >=
                                      0.6
                                  ? 0.0
                                  : MediaQuery.of(context).size.height * 0.025),
                          child: Text(
                            "Age: ${data.age}",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'neo',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Id:${data.id} ",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'neo',
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Date: ${data.date}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'neo',
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.height * 0.01,
              child: CircleAvatar(
                  radius: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.047
                      : MediaQuery.of(context).size.height * 0.047,
                  backgroundImage: NetworkImage(data.user_image ?? '')),
            )
          ],
        ),
      ),
    );
  }
}
