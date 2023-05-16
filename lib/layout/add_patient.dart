import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../controller/ptient_controller.dart';
import '../helper/my_appbar.dart';
import '../model/sheet.dart';
import '../widget/editable/dx_widget.dart';
import '../widget/editable/patient_info.dart';
import '../widget/editable/radiology_widget.dart';
import '../widget/editable/rx_widget.dart';
import '../widget/my_float.dart';

class PatientAdd extends StatefulWidget {
  PatientAdd({super.key, this.open, this.user, this.method, this.sheetId});
  final String? open;
  String? method;
  int? sheetId;
  UserInfo? user;
  @override
  State<PatientAdd> createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.method == null) {
      Provider.of<PatientController>(context, listen: false).createSheetToSend(
        '',
        0,
        '',
        Dx(content: '', file_url: []),
        '',
      );
    } else {
      switch (widget.method) {
        case 'rx':
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age,
                  rx: [],
                  sheetId: widget.sheetId);

          break;
        case 'radiology':
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age,
                  sheetId: widget.sheetId,
                  radiology: []);
          break;
        case 'lab':
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age,
                  sheetId: widget.sheetId,
                  lab: []);
          break;
        case 'ultrasound':
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age,
                  sheetId: widget.sheetId,
                  ultrasound: []);
          break;
        case 'other':
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age,
                  sheetId: widget.sheetId,
                  other: []);
          break;
        default:
          Provider.of<PatientController>(context, listen: false)
              .createSheetToSend(
                  widget.user!.patient_name,
                  widget.user!.gender == 'male' ? 0 : 1,
                  widget.user!.weight ?? '',
                  Dx(content: '', file_url: []),
                  widget.user!.age);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SheetToSend sheet = Provider.of<PatientController>(context).sheetToSend!;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
          child: MyAppbar(
            title: 'Patient',
            isElevated: 0.0,
            opacity: 1.0,
            leading: true,
          ),
          preferredSize: Size(_width, _height * 0.0615)),
      body: Stack(
        children: [
          ListView(shrinkWrap: false, children: [
            Container(
              height: 10,
            ),
            PatientInfoEditable(userInfo: widget.user),
            Container(
              height: 10,
            ),
            DxWidget(),
            sheet.rx == null ? Container() : RxWidget(),
            sheet.radiology != null
                ? RadiologyWidget(
                    type: 'radiology',
                  )
                : Container(),
            sheet.lab != null
                ? LabTestWidget(
                    tests: sheet.lab,
                  )
                : Container(),
            sheet.ultrasound != null
                ? RadiologyWidget(
                    type: 'ultrasound',
                  )
                : Container(),
            sheet.other != null
                ? RadiologyWidget(
                    type: 'other',
                  )
                : Container(),
          ]),
          MyFloat(
            editable: true,
            offset: Offset(
                MediaQuery.of(context).size.width - 100,
                MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height * 0.7),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 20),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SubmitButtons(
                isLoading: isLoading,
                color: 0xffED1852,
                text: 'Delete',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('delete changes?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .dismissSheet();
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color(0xffED1852),
                                  ),
                                ))
                          ],
                        );
                      }).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.1,
              // ),
              SubmitButtons(
                isLoading: isLoading,
                color: 0xff0199EC,
                text: 'Save',
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (widget.method == null) {
                    Provider.of<PatientController>(context, listen: false)
                        .storeNewSheet()
                        .then((value) {
                      Provider.of<PatientController>(context, listen: false)
                          .getShowSheet(value['update_id'].toString())
                          .then((value) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/patient', ModalRoute.withName('/'));
                      });
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    }).catchError((e) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  } else {
                    await Provider.of<PatientController>(context, listen: false)
                        .sendNewUpadte()
                        .then((value) {
                      Provider.of<PatientController>(context, listen: false)
                          .getShowSheet(value['update_id'].toString())
                          .then((value) {
                        Navigator.pushReplacementNamed(context, '/patient');
                      });
                      setState(() {
                        isLoading = false;
                      });
                    }).catchError((e) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButtons extends StatelessWidget {
  SubmitButtons(
      {super.key,
      required this.color,
      required this.text,
      this.onTap,
      required this.isLoading});
  final int color;
  final String text;
  final Function()? onTap;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          onTap!();
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.05,
          child: Material(
            color: isLoading ? Colors.grey : Color(color),
            borderRadius: BorderRadius.circular(20),
            elevation: 3,
            child: Center(
                child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )),
          )),
    );
  }
}

class LabTestWidget extends StatelessWidget {
  LabTestWidget({this.tests, super.key});
  List<Lab>? tests;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(9),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lab Test Resault',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'neo',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<PatientController>(context, listen: false)
                            .removeLabTestContainer();
                      },
                      child: SvgPicture.asset('assets/images/undo.svg'),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Center(
                  child: Text('Test'),
                ),
                ...tests!.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 1,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.labtest_name),
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<PatientController>(context,
                                              listen: false)
                                          .removeLabTest(e.id);
                                    },
                                    child: SvgPicture.asset(
                                        'assets/images/undo.svg'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    BottomSheet(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [Text('add Test'), Icon(Icons.add)],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
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
          type: 'lab',
        );
      },
    );
  }
}
