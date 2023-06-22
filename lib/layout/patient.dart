import 'dart:io';

import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../helper/my_appbar.dart';
import '../model/sheet.dart';
import '../widget/doctor_data_widget.dart';
import '../widget/my_float.dart';
import '../widget/patient_data_widget.dart';
import '../widget/uneditable/dx_widget.dart';
import '../widget/uneditable/radiology_widget.dart';
import '../widget/uneditable/rx_widget.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/pdf_view.dart';
import '../model/user_to_send.dart';

class PatientScreen extends StatefulWidget {
  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Update? data = Provider.of<PatientController>(context).sheet;

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {},
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                      child: Text(
                    'Print',
                    style: TextStyle(color: Color(0xffF7227F)),
                  ))),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xffF7227F), width: 2),
                  )),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                      child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ))),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xffF7227F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                sendBottomSheet(context, type: '6');
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                    child: Text('Send', style: TextStyle(color: Colors.white)),
                  )),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xff0199EC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
          child: MyAppbar(
            title: 'Patient',
            isElevated: 0.0,
            opacity: 1.0,
            leading: true,
            actions: [
              IconButton(
                  onPressed: () {
                    BottomSheet(context);
                  },
                  icon: SvgPicture.asset('assets/images/calinder.svg'))
            ],
          ),
          preferredSize: Size(_width, _height * 0.0615)),
      body: data == null
          ? LaunchScreen()
          : Stack(
              children: [
                ListView(shrinkWrap: false, children: [
                  DoctorDataWidget(
                    doctorName: data.doctor_info.full_name,
                    specialty: data.doctor_info.bio,
                    doctorId: data.doctor_info.id.toString(),
                  ),
                  Container(
                    height: 10,
                  ),
                  PatientDataWidget(
                    patientName: data.patientInfo.patient_name,
                    weight: data.patientInfo.weight,
                    age: data.patientInfo.age,
                    sheetId: data.id.toString(),
                    date: data.date,
                    gender: data.patientInfo.gender,
                    edit: true,
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 3,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(27),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: data.linked == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Link this sheet',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      bool isFamily;
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              padding: EdgeInsets.all(12),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'data',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              Provider.of<PatientController>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .searchToLink(
                                                                      '');

                                                              isFamily = true;
                                                              showModalBottomSheet(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return LinkBottomSheet(
                                                                      isFamily:
                                                                          isFamily
                                                                              ? 1
                                                                              : 0,
                                                                    );
                                                                  }).then((value) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            },
                                                            child:
                                                                Text('Family')),
                                                      ),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary: Color(
                                                                        0xffF7227F)),
                                                            onPressed: () {
                                                              Provider.of<PatientController>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .searchToLink(
                                                                      '');

                                                              isFamily = false;
                                                              showModalBottomSheet(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return LinkBottomSheet(
                                                                      isFamily:
                                                                          isFamily
                                                                              ? 1
                                                                              : 0,
                                                                    );
                                                                  }).then((value) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            },
                                                            child: Text(
                                                                'indivitual')),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff0199EC),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Link',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'neo'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Linked to: ',
                                    style: TextStyle(
                                        color: Color(0xff0199EC),
                                        fontSize: 20,
                                        fontFamily: 'neo'),
                                  ),
                                  Text(
                                    data.linked!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'neo'),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                 if(data.dx != null) DxU(
                    data: data.dx!.content,
                    image: data.dx!.file_url,
                  ),
                  data.rx.length == 0
                      ? Container()
                      : RxU(
                          drugs: data.rx,
                        ),
                  data!.radiology == null
                      ? Container()
                      : data.radiology.length == 0
                          ? Container()
                          : RadiologyU(
                              tests: data.radiology,
                              type: 'radiology',
                            ),
                  data.lab.length == 0
                      ? Container()
                      : LabContainerU(data: data),
                  data.ultrasound == null
                      ? Container()
                      : data.ultrasound.length == 0
                          ? Container()
                          : RadiologyU(
                              type: 'ultrasound',
                              tests: data.ultrasound,
                            ),
                  data.other == null
                      ? Container()
                      : data.other.length == 0
                          ? Container()
                          : RadiologyU(
                              type: 'other',
                              tests: data.other,
                            ),
                ]),
                MyFloat(
                    editable: false,
                    offset: Offset(MediaQuery.of(context).size.width - 100,
                        MediaQuery.of(context).size.height - 150)),
              ],
            ),
    );
  }

  void createPdfFile() async {
    final pdfFile = File('${(await getTemporaryDirectory()).path}/example.pdf');
    final pdfContent = 'Hello, world!'; // Replace with your PDF content

    await pdfFile.writeAsString(pdfContent);
    if (await canLaunch(pdfFile.path)) {
      await launch(pdfFile.path);
    } else {
      throw 'Could not launch ${pdfFile.path}';
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
        return SelectUpdate();
      },
    );
  }

  Future<void> sendBottomSheet(BuildContext context,
      {required String type}) async {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return NewWidget(
          type: type,
        );
      },
    );
  }
}

class LinkBottomSheet extends StatefulWidget {
  const LinkBottomSheet({
    super.key,
    required this.isFamily,
  });
  final int isFamily;
  @override
  State<LinkBottomSheet> createState() => _LinkBottomSheetState();
}

class _LinkBottomSheetState extends State<LinkBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Link Patient Sheet',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              height: 10,
            ),
            TextField(
              onChanged: (value) {
                Provider.of<PatientController>(context, listen: false)
                    .searchToLink(value);
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(9)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(9)),
              ),
            ),
            Container(
              height: 30,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...Provider.of<PatientController>(context)
                      .usersToLink
                      .map((e) {
                    return UserTolLink(
                      user: e,
                      isFamily: widget.isFamily,
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserTolLink extends StatelessWidget {
  const UserTolLink({
    required this.user,
    super.key,
    required this.isFamily,
  });
  final UserToSend user;
  final int isFamily;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<PatientController>(context, listen: false)
            .linkUser(user.id, isFamily)
            .then((value) {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.name,
                  style: TextStyle(fontSize: 19),
                ),
                Container(
                  height: 5,
                ),
                Text(user.accountType),
              ],
            ),
            Container(
              width: 15,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.image,
              ),
              radius: MediaQuery.of(context).size.width * 0.06,
            )
          ],
        ),
      ),
    );
  }
}

class LabContainerU extends StatelessWidget {
  const LabContainerU({
    super.key,
    required this.data,
  });

  final Update? data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      ],
                    ),
                    Container(
                      height: 20,
                    ),
                    ...data!.lab!.map(
                      (e) {
                        if (e!.isAccepted == 0) {
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
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(e!.labtest_name),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ExpansionTile(
                            title: Text(e.labtest_name),
                            children: [
                              ...e.content!.map((element) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Material(
                                          elevation: 1,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(element!['name']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 1,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(element['result']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Material(
                                          elevation: 1,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(element['nv']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          );
                        }
                      },
                    ),
                    Container(
                      height: 50,
                    ),
                  ],
                ),
              )),
        ),
        Positioned(
            bottom: 0,
            left: 40,
            child: GestureDetector(
                onTap: () {
                  BottomSheet(context, type: '3');
                },
                child: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/send.svg',
                    width: 28,
                  ),
                  backgroundColor: Colors.white,
                ))),
      ],
    );
  }

  Future<void> BottomSheet(BuildContext context, {required String type}) async {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return NewWidget(
          type: type,
        );
      },
    );
  }
}

class SelectUpdate extends StatefulWidget {
  const SelectUpdate({super.key});

  @override
  State<SelectUpdate> createState() => _SelectUpdateState();
}

class _SelectUpdateState extends State<SelectUpdate> {
  @override
  Widget build(BuildContext context) {
    Update? data = Provider.of<PatientController>(context).sheet;

    return data == null
        ? Container()
        : Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Patient Calender',
                      style: TextStyle(fontSize: 26, fontFamily: 'neo'),
                    ),
                    Container(
                      height: 30,
                    ),
                    ...data.update_list.map((e) => GestureDetector(
                          onTap: () {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .getShowSheet(e['id'].toString());
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff0199EC),
                                ),
                                borderRadius: BorderRadius.circular(9)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(e['date']),
                            )),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
