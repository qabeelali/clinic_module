import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_nps/layout/ultrasound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controller/pahrmacy_controller.dart';
import '../controller/provider.dart';
import '../helper/launch_screen.dart';
import '../model/pharmacy_model.dart';
import '../model/sheet.dart';
import '../view/image_screen.dart';
import '../widget/pharmacy_appbar.dart';
import 'add_patient.dart';

class RadiologyPage extends StatefulWidget {
  const RadiologyPage({super.key});

  @override
  State<RadiologyPage> createState() => _RadiologyPageState();
}

class _RadiologyPageState extends State<RadiologyPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Recieved? recieved = Provider.of<PharmacyController>(context).received;

    return Scaffold(
      backgroundColor: Colors.white,
      body: recieved == null
          ? LaunchScreen()
          : Column(
              children: [
                PharmacyAppBar(),
                Expanded(
                    child: ListView(
                  children: recieved.is_seen!
                      ? [
                          ...recieved.readiology!.mapIndexed((index, element) {
                            return RadiologySelectWidget(
                              state: 2,
                              selected: false,
                              index: index,
                              seen: true,
                              e: element,
                              image: element.file_url[0]['file'],
                              description: element.received_note,
                            );
                          })
                        ]
                      : Provider.of<provider>(context).phase == 0
                          ? [
                              ...recieved!.readiology!
                                  .map((e) => RadiologySelectWidget(
                                        state: 0,
                                        e: e,
                                        selected:
                                            Provider.of<PharmacyController>(
                                                    context,
                                                    listen: false)
                                                .selected
                                                .where((element) =>
                                                    element['id'] == e.id)
                                                .isNotEmpty,
                                      ))
                            ]
                          : Provider.of<provider>(context).phase == 1
                              ? [
                                  ...Provider.of<PharmacyController>(context)
                                      .selected
                                      .mapIndexed(
                                          (index, e) => RadiologySelectWidget(
                                                state: 1,
                                                e: e,
                                                selected: false,
                                                index: index,
                                                image: e['files'] != null
                                                    ? e['files']
                                                    : null,
                                                description: e['received_note'],
                                              ))
                                ]
                              : [
                                  ...Provider.of<PharmacyController>(context,
                                          listen: false)
                                      .selected
                                      .mapIndexed((index, element) {
                                    return RadiologySelectWidget(
                                      state: 2,
                                      selected: Provider.of<PharmacyController>(
                                              context,
                                              listen: false)
                                          .accepted
                                          .where(
                                              (e) => element['id'] == e!['id'])
                                          .isNotEmpty,
                                      index: index,
                                      e: element,
                                      image: element['files'] != null
                                          ? element['files'][0]
                                          : null,
                                      description: element['received_note'],
                                    );
                                  })
                                ],
                ))
              ],
            ),
      bottomNavigationBar: recieved == null || recieved.is_seen!
          ? Container(
              height: 1,
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SubmitButtons(
                    isLoading: isLoading,
                    color: 0xffED1852,
                    text:
                        Provider.of<provider>(context, listen: false).phase == 0
                            ? 'Reject'
                            : 'Back',
                    onTap: () {
                      if (Provider.of<provider>(context, listen: false).phase ==
                          0) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('Reject order?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                          color: Color(0xffED1852),
                                        ),
                                      ))
                                ],
                              );
                            }).then((value) {
                          if (value) {
                            if (value != null) {
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<PharmacyController>(context,
                                      listen: false)
                                  .accept(recieved!.id,
                                      reject: '', type: 'radiology')
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              Navigator.of(context).pop();
                            }
                          }
                        });
                      } else if (Provider.of<provider>(context, listen: false)
                              .phase ==
                          1) {
                        Provider.of<PharmacyController>(context, listen: false)
                            .clearAccepted();
                        Provider.of<provider>(context, listen: false)
                            .downPhase();
                      } else {
                        Provider.of<provider>(context, listen: false)
                            .downPhase();
                      }
                    },
                  ),
                  SubmitButtons(
                    isLoading: isLoading,
                    color: 0xff0199EC,
                    text:
                        Provider.of<provider>(context, listen: false).phase == 2
                            ? 'Accept'
                            : 'Next',
                    onTap: () {
                      switch (
                          Provider.of<provider>(context, listen: false).phase) {
                        case 0:
                          Provider.of<provider>(context, listen: false)
                              .changePhase(1);
                          break;
                        case 1:
                          Provider.of<provider>(context, listen: false)
                              .changePhase(2);
                          break;
                        case 2:
                          setState(() {
                            isLoading = true;
                          });
                          Provider.of<PharmacyController>(context,
                                  listen: false)
                              .accept(recieved!.id, type: 'radiology')
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          Navigator.of(context).pop();
                          break;
                        default:
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }
}

class RadiologySelectWidget extends StatefulWidget {
  final dynamic e;
  bool selected;
  int state;
  int? index;
  String? description;
  dynamic image;
  bool? seen;
  RadiologySelectWidget({
    required this.selected,
    required this.state,
    required this.e,
    this.description,
    this.seen,
    this.image,
    this.index,
    super.key,
  });

  @override
  State<RadiologySelectWidget> createState() => _RadiologySelectWidgetState();
}

class _RadiologySelectWidgetState extends State<RadiologySelectWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case 0:
        return Container(
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              print(widget.e.id);
              Provider.of<PharmacyController>(context, listen: false)
                  .addToSelected(widget.e.id, name: widget.e.radiology_name);
            },
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              elevation: 0.5,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                decoration: BoxDecoration(
                    border: widget.selected
                        ? Border.all(color: Color(0xff0199EC))
                        : null,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                      ),
                      Text(widget.e.radiology_name),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: widget.selected
                                  ? Color(0xff0199EC)
                                  : Color(0xffF7227F)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedOpacity(
                          opacity: widget.selected ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: Icon(
                            Icons.done,
                            color: Color(0xff0199EC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      case 1:
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15,
          child: GestureDetector(
            onTap: () {
              BottomSheet(context,
                      index: widget.index!,
                      text: widget.description,
                      images: widget.image ?? [])
                  .then((value) {
                if (value == 'next') {}
              });
            },
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 3,
                          child: Center(child: Text(widget.e['name'])),
                        )),
                    Container(
                      height: 10,
                    ),
                    Expanded(
                        flex: 2,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 3,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.description == null
                                    ? Text(
                                        'T',
                                        style: TextStyle(
                                            fontSize: 30, fontFamily: 'neo'),
                                      )
                                    : Container(),
                                Text(
                                  widget.description ?? 'ext area',
                                  style: TextStyle(fontFamily: 'neo'),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                )),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 3,
                  child: Center(
                    child: widget.image != null
                        ? Image.file(widget.image![0])
                        : SvgPicture.asset('assets/images/image.svg'),
                  ),
                ))
              ],
            ),
          ),
        );
      case 2:
        return Stack(
          children: [
            Container(
                margin: EdgeInsets.only(top: 22, left: 3, right: 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.selected) {
                                    Provider.of<PharmacyController>(context,
                                            listen: false)
                                        .removeFromAccepted(widget.index!);
                                  } else {
                                    Provider.of<PharmacyController>(context,
                                            listen: false)
                                        .addToAccepted(widget.index!);
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(9),
                                  elevation: 3,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(widget.seen != null
                                        ? widget.e.radiology_name
                                        : widget.e['name']),
                                  ),
                                ),
                              )),
                          Container(height: 10),
                          Expanded(
                              flex: 3,
                              child: Material(
                                borderRadius: BorderRadius.circular(9),
                                elevation: 3,
                                color: Colors.white,
                                child: Center(
                                  child: Text(widget.description!),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.seen != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                  image: widget.e.file_url, tag: 'tag'),
                            ));
                          }
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(9),
                          elevation: 3,
                          color: Colors.white,
                          child: widget.seen != null
                              ? Image.network(widget.image)
                              : Image.file(widget.image!),
                        ),
                      ),
                    )
                  ],
                )),
            widget.seen != null
                ? Container()
                : Positioned(
                    top: 5,
                    left: MediaQuery.of(context).size.width * 0.2,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.selected) {
                          Provider.of<PharmacyController>(context,
                                  listen: false)
                              .removeFromAccepted(widget.index!);
                        } else {
                          Provider.of<PharmacyController>(context,
                                  listen: false)
                              .addToAccepted(widget.index!);
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: widget.selected
                                ? null
                                : Border.all(color: Color(0xff0199EC)),
                            color: widget.selected
                                ? Color(0xffF7227F)
                                : Colors.transparent),
                        child: AnimatedOpacity(
                          opacity: widget.selected ? 1 : 0,
                          duration: Duration(milliseconds: 100),
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        );
      default:
        return Container();
    }
  }

  Future BottomSheet(BuildContext context,
      {required int index, String? text, required List images}) async {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return RadiologyBottomSheet(
          index,
          text: text,
          images: images,
        );
      },
    );
  }
}
