import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../controller/pahrmacy_controller.dart';
import '../controller/provider.dart';
import '../controller/user_controller.dart';
import '../model/pharmacy_model.dart';

class PharmacyWidget extends StatelessWidget {
  const PharmacyWidget({
    super.key,
    required this.data,
    required this.isSeen,
  });
  final PharmacyItem data;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<userController>(context, listen: false).user!.type ==
            2) {
          Provider.of<PharmacyController>(context, listen: false)
              .getRecievedData(data.update_id);
          Navigator.of(context).pushNamed('/other');
        } else if (Provider.of<userController>(context, listen: false)
                .user!
                .type ==
            4) {
          Provider.of<PharmacyController>(context, listen: false)
              .getRecievedData(data.update_id);
          Navigator.of(context).pushNamed('/radiology');
        } else if (Provider.of<userController>(context, listen: false)
                .user!
                .type ==
            6) {
          Provider.of<PharmacyController>(context, listen: false)
              .getRecievedData(data.update_id);
          Navigator.of(context).pushNamed('/lab');
        } else if (Provider.of<userController>(context, listen: false)
                .user!
                .type ==
            5) {
          Provider.of<PharmacyController>(context, listen: false)
              .getRecievedData(data.update_id);
          Navigator.of(context).pushNamed('/ultrasound');
        } else {
          Provider.of<PharmacyController>(context, listen: false)
              .getRecievedData(data.update_id);
          Navigator.of(context).pushNamed('/pharmacy_sheet');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSeen ? Color(0xff0199EC) : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? null
                        : MediaQuery.of(context).size.height * 0.1,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.91,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Patient Name: ${data.name}",
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class action extends StatefulWidget {
  const action({
    super.key,
    required this.color,
    required this.name,
  });
  final int color;
  final String name;

  @override
  State<action> createState() => _actionState();
}

class _actionState extends State<action> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<provider>(context, listen: false)
        .changePatientSheetClickablety(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<provider>(context, listen: false)
        .changePatientSheetClickablety(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : (MediaQuery.of(context).size.height * 0.15) * 0.8,
      width: (MediaQuery.of(context).size.width * 0.298) * 0.8,
      child: Center(
          child: Text(
        widget.name,
        style: TextStyle(
            fontFamily: 'neo',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600),
      )),
      decoration: BoxDecoration(
          color: Color(widget.color), borderRadius: BorderRadius.circular(12)),
    );
  }
}
