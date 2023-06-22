import 'dart:math';

import '../../controller/ptient_controller.dart';
import '../../helper/launch_screen.dart';
import '../../model/sheet.dart';
import '../../model/user_to_send.dart';
import '../../widget/uneditable/sub_widgets/radiology_sub_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class RadiologyU extends StatelessWidget {
  RadiologyU({super.key, required this.tests, required this.type});
  final List tests;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(0, 01, 0, 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: Color(0xff000000).withOpacity(0.2)),
              ]),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'radiology'
                      ? 'Radiology results'
                      : type == 'ultrasound'
                          ? 'Ultrasound results'
                          : 'Other Test',
                  style: TextStyle(fontFamily: 'neo', fontSize: 26),
                ),
                Container(height: 10),
                ...tests.map((e) {
                  if (e!.isAccepted == 1) {
                    return RadiologySubWidget(
                      name: type == 'radiology' ? e.radiology_name : e.name,
                      des: e.description_note,
                      image: e.file_url,
                    );
                  }
                  return UnEcceptedRadiology(
                    e: e,
                    type: type,
                  );
                })
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 40,
            child: GestureDetector(
                onTap: () {
                  BottomSheet(context,
                      type: type == 'radiology'
                          ? '2'
                          : type == 'ultrasound'
                              ? '4'
                              : '5');
                },
                child: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/send.svg',
                    width: 28,
                  ),
                  backgroundColor: Colors.white,
                )))
      ],
    );
  }
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

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('bottom sheet');
    setState(() {
      isLoading = true;
    });
    Provider.of<PatientController>(context, listen: false)
        .getUsersToSend(type: widget.type == '6' ? '5' : widget.type)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<UserToSend?> _userToSend =
        Provider.of<PatientController>(context).usersToSend;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 30, 8.0, 8.0),
          child: Column(
            children: [
              const Text(
                'Send Patient Info',
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'neo',
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (e) {
                        Provider.of<PatientController>(context, listen: false)
                            .getUsersToSend(type: widget.type, search: e);
                      },
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'neo',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'search',
                        prefixIconColor: Color(0xff626262),
                        hoverColor: Color(0xffF6F6F6),
                        focusColor: Color(0xffF6F6F6),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffF6F6F6)),
                            borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffF6F6F6)),
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.only(right: 8),
                        fillColor: Color(0xffF6F6F6),
                        filled: true,
                        prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.7)),
                                    child: Icon(
                                      Icons.close_outlined,
                                      color: Colors.white,
                                    )))),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: isLoading
                      ? Center(
                          child: LaunchScreen(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ..._userToSend.map((e) {
                              print(e);
                              return UserToSendWidget(
                                name: e!.name,
                                // onStart: () {
                                //   print('object');
                                //   setState(() {
                                //     isLoading = true;
                                //   });
                                // },
                                // onEnd: () {
                                //   setState(() {
                                //     isLoading = false;
                                //   });
                                //   Navigator.of(context).pop();
                                // },
                                id: e.id,
                                type: widget.type,
                                accountType: e.accountType,
                                image: e.image,
                              );
                            })
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserToSendWidget extends StatefulWidget {
  UserToSendWidget({
    required this.name,
    required this.type,
    required this.id,
    required this.image,
    required this.accountType,
    super.key,
  });

  String name;
  String type;
  String image;
  String accountType;
  int id;

  @override
  State<UserToSendWidget> createState() => _UserToSendWidgetState();
}

class _UserToSendWidgetState extends State<UserToSendWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        if (widget.type == '1' || widget.type == '3' || widget.type == '6') {
          if (widget.type == '1' || widget.type == '6') {
            Provider.of<PatientController>(context, listen: false)
                .checkSearch(widget.id, widget.type)
                .then((value) {
              Provider.of<PatientController>(context, listen: false)
                  .sendSheet(type: widget.type, userId: widget.id)
                  .then((value) {
                Navigator.of(context).pop();
              });
            }).catchError((e) {
              print(e);
              showDialog(
                  context: context,
                  builder: (context) {
                    List missing = e['data'];
                    return Center(
                      child: Container(
                          height: MediaQuery.of(context).size.width * 0.6,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'warning',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'neo',
                                      color: Colors.red),
                                ),
                                Text(
                                  e['message'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'neo',
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ...missing.mapIndexed((index, element) =>
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${index + 1}- ',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                '${element}',
                                                style: TextStyle(
                                                    fontFamily: 'neo'),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('search another pharmacy')),
                                    Container(
                                      width: 10,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Provider.of<PatientController>(
                                                  context,
                                                  listen: false)
                                              .sendSheet(
                                                  type: widget.type,
                                                  userId: widget.id)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          'Send',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    );
                  });
            });
          } else {
            Provider.of<PatientController>(context, listen: false)
                .sendSheet(type: widget.type, userId: widget.id)
                .then((value) {
              Navigator.of(context).pop();
            });
          }

          // setState(() {
          //   isLoading = false;
          // });
        } else {
          Provider.of<PatientController>(context, listen: false)
              .sendSheet(type: widget.type, userId: widget.id)
              .then((value) {
            Navigator.of(context).pop();
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'neo',
                        fontWeight: FontWeight.w600,
                        color: isLoading ? Colors.grey : null),
                  ),
                  Text(widget.accountType,
                      style: TextStyle(
                          fontSize: 10,
                          color: isLoading ? Colors.grey : Color(0xff626262),
                          fontFamily: 'neo',
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.13 / 2,
              backgroundImage: NetworkImage(widget.image),
              foregroundColor: isLoading ? Colors.grey : null,
            )
          ],
        ),
      ),
    );
  }
}

class UnEcceptedRadiology extends StatelessWidget {
  UnEcceptedRadiology({super.key, required this.e, required this.type});
  dynamic e;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.049,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(6),
                child: Center(
                    child: Text(
                  type == 'radiology' ? e.radiology_name : e.name,
                  style: TextStyle(fontFamily: 'neo', fontSize: 18),
                )),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.089,
                maxHeight: MediaQuery.of(context).size.height * 0.090,
              ),
              child: GestureDetector(
                onTap: () {
                  showMyDialog(context,
                      title: type == 'radiology'
                          ? 'Radiology Notes'
                          : 'Ultrasound Notes',
                      content: e.description_note,
                      titleColor: 0xff0199EC);
                },
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.description_note,
                      style: TextStyle(
                        fontFamily: 'neo',
                        fontSize: 18,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showMyDialog(BuildContext context,
      {required String title,
      required String content,
      required int titleColor}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 5,
                  children: [
                    Center(
                        child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'neo',
                          fontSize: 25,
                          color: Color(titleColor),
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 3),
                                blurRadius: 1)
                          ]),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        content,
                        style: TextStyle(fontFamily: 'neo', fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
