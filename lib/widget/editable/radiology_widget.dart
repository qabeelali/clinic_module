import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_nps/widget/editable/rx_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controller/ptient_controller.dart';

class RadiologyWidget extends StatefulWidget {
  const RadiologyWidget({super.key, required this.type});
  final String type;
  @override
  State<RadiologyWidget> createState() => _RadiologyWidgetState();
}

class _RadiologyWidgetState extends State<RadiologyWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'radiology':
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 01, 0, 65),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: const Color(0xff000000).withOpacity(0.2)),
              ]),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Radiology',
                          style: TextStyle(fontFamily: 'neo', fontSize: 26),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .removeRadiologyContainer();
                                },
                                child:
                                    SvgPicture.asset('assets/images/undo.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 25,
                    ),
                    ...Provider.of<PatientController>(context, listen: false)
                        .sheetToSend!
                        .radiology!
                        .mapIndexed(
                          (i, e) => RadiologySubWidgetEditable(
                              name: e.radiology_name,
                              index: i,
                              type: 'radiology'),
                        ),
                    GestureDetector(
                      onTap: () {
                        BottomSheet(context);
                      },
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Add Radiology'),
                          )),
                    )
                  ])),
        );

      case 'ultrasound':
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 01, 0, 65),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: const Color(0xff000000).withOpacity(0.2)),
              ]),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ultrasound',
                          style: TextStyle(fontFamily: 'neo', fontSize: 26),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .removeUltrasoundContainer();
                                },
                                child:
                                    SvgPicture.asset('assets/images/undo.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 25,
                    ),
                    ...Provider.of<PatientController>(context, listen: false)
                        .sheetToSend!
                        .ultrasound!
                        .mapIndexed(
                          (i, e) => RadiologySubWidgetEditable(
                            name: e.name,
                            index: i,
                            type: 'ultrasound',
                          ),
                        ),
                    GestureDetector(
                      onTap: () {
                        BottomSheet(context);
                      },
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Add Ultrasound'),
                          )),
                    )
                  ])),
        );
      case 'other':
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 01, 0, 65),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: const Color(0xff000000).withOpacity(0.2)),
              ]),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'other test',
                          style: TextStyle(fontFamily: 'neo', fontSize: 26),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .removeOtherContainer();
                                },
                                child:
                                    SvgPicture.asset('assets/images/undo.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 25,
                    ),
                    ...Provider.of<PatientController>(context, listen: false)
                        .sheetToSend!
                        .other!
                        .mapIndexed(
                          (i, e) => RadiologySubWidgetEditable(
                            name: e.name,
                            index: i,
                            type: 'other',
                          ),
                        ),
                    GestureDetector(
                      onTap: () {
                        BottomSheet(context);
                      },
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Add other'),
                          )),
                    )
                  ])),
        );

      default:
        return Container();
    }
  }

  Future<void> BottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AddDrugs(
          type: widget.type,
        );
      },
    );
  }
}

class RadiologySubWidgetEditable extends StatelessWidget {
  final String name;
  final int index;
  final String type;
  const RadiologySubWidgetEditable({
    required this.name,
    required this.index,
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        elevation: 3,
        child: Column(
          children: [
            Text(
              'Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            Container(
              height: 20,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 18, fontFamily: 'neo'),
            ),
            type == 'radiology'
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: TextField(
                      onChanged: (des) {
                        Provider.of<PatientController>(context, listen: false)
                            .changeRadiologyDecription(
                                description: des, index: index);
                      },
                      minLines: 4,
                      maxLines: 6,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffF7227F),
                            ),
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffF7227F),
                            ),
                            borderRadius: BorderRadius.circular(9)),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: type == 'ultrasound'
                          ? Text(Provider.of<PatientController>(context,
                                  listen: false)
                              .sheetToSend!
                              .ultrasound![index]
                              .description_note)
                          : Text(Provider.of<PatientController>(context,
                                  listen: false)
                              .sheetToSend!
                              .other![index]
                              .description_note),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
