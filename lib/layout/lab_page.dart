import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import '../controller/provider.dart';
import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../layout/add_patient.dart';
import '../widget/pharmacy_appbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../controller/pahrmacy_controller.dart';
import '../model/pharmacy_model.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _RadiologyPageState();
}

class _RadiologyPageState extends State<LabPage> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement dispose
    super.initState();
    Provider.of<PharmacyController>(context, listen: false).clearAccepted();

    Provider.of<provider>(context, listen: false).changePhase(0);
  }

  @override
  Widget build(BuildContext context) {
    Recieved? recieved = Provider.of<PharmacyController>(context).received;
    // print(recieved!.lab![1].isAccepted);
    var phase2 = Provider.of<provider>(context).phase;
    return Scaffold(
      backgroundColor: Colors.white,
      body: recieved == null
          ? LaunchScreen()
          : Column(
              children: [
                PharmacyAppBar(),
                Expanded(
                    child: ListView(
                  ///
                  ///To Do: replace this true with request.seen==null
                  ///
                  children: recieved.is_seen==null
                      ? [
                          if (phase2 == 0)
                            ...recieved.lab.mapIndexed((index, e) {
                              if (e.isAccepted == 0) {
                                return RadiologySelectWidget(
                                    selected: Provider.of<PharmacyController>(
                                            context,
                                            listen: false)
                                        .selected
                                        .where(
                                            (element) => element['id'] == e.id)
                                        .isNotEmpty,
                                    state: 0,
                                    e: e);
                              } else {
                                if (e.isAccepted ==1 && phase2 == 0) {
                                  return Container(
                                      child: Material(
                                    color: Colors.white,
                                    child: Column(children: [
                                      ExpansionTile(
                                        title: Text(e.labtest_name),
                                        children: [
                                          ...e.content!.map((e) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                  Container(width: 5),
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['result'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                  Container(width: 5),
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['nv'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                ],
                                              ),
                                            );
                                          })
                                        ],
                                      )
                                    ]),
                                  ));
                                }
                                return Container();
                              }
                            }),
                          if (phase2 == 1)
                            ...Provider.of<PharmacyController>(context)
                                .selected
                                .mapIndexed((index, e) => RadiologySelectWidget(
                                      state: 1,
                                      e: e,
                                      selected: false,
                                      index: index,
                                      image: e['files'] != null
                                          ? e['files'][0]
                                          : null,
                                      description: e['received_note'],
                                    )),
                       if(phase2==2)     ...Provider.of<PharmacyController>(
                                              context,
                                              listen: false)
                                          .selected
                                          .mapIndexed((index, element) {
                                        if (element['content'] != null) {
                                          return Container(
                                              child: Material(
                                            color: Colors.white,
                                            child: Column(children: [
                                              ExpansionTile(
                                                title: Text(element['name']),
                                                children: [
                                                  ...element['content']
                                                      .map((e) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                          Container(width: 5),
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['result'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                          Container(width: 5),
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['nv'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ),
                                                    );
                                                  })
                                                ],
                                              )
                                            ]),
                                          ));
                                        }
                                        return RadiologySelectWidget(
                                          state: 2,
                                          selected:
                                              Provider.of<PharmacyController>(
                                                      context,
                                                      listen: false)
                                                  .accepted
                                                  .where((e) =>
                                                      element['id'] == e!['id'])
                                                  .isNotEmpty,
                                          index: index,
                                          e: element,
                                          image: element['files'] != null
                                              ? element['files'][0]
                                              : null,
                                          description: element['received_note'],
                                        );
                                      })
                        ]
                      : recieved.is_seen!
                          ? [
                              ...recieved.lab!.mapIndexed((index, element) {
                                if (element != null) {
                                  return Container(
                                      child: Material(
                                    color: Colors.white,
                                    child: Column(children: [
                                      ExpansionTile(
                                        title: Text(element.labtest_name),
                                        children: [
                                          ...element.content!.map((e) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                  Container(width: 5),
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['result'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                  Container(width: 5),
                                                  Expanded(
                                                      child: Material(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Center(
                                                              child: Text(
                                                                e['nv'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ))),
                                                ],
                                              ),
                                            );
                                          })
                                        ],
                                      )
                                    ]),
                                  ));
                                }
                                return Container();
                              })
                            ]
                          : phase2 == 0
                              ? [
                                  ...recieved.lab!
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
                              : phase2 == 1
                                  ? [
                                      ...Provider.of<PharmacyController>(
                                              context)
                                          .selected
                                          .mapIndexed((index, e) =>
                                              RadiologySelectWidget(
                                                state: 1,
                                                e: e,
                                                selected: false,
                                                index: index,
                                                image: e['files'] != null
                                                    ? e['files'][0]
                                                    : null,
                                                description: e['received_note'],
                                              ))
                                    ]
                                  : [
                                      ...Provider.of<PharmacyController>(
                                              context,
                                              listen: false)
                                          .selected
                                          .mapIndexed((index, element) {
                                        if (element['content'] != null) {
                                          return Container(
                                              child: Material(
                                            color: Colors.white,
                                            child: Column(children: [
                                              ExpansionTile(
                                                title: Text(element['name']),
                                                children: [
                                                  ...element['content']
                                                      .map((e) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                          Container(width: 5),
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['result'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                          Container(width: 5),
                                                          Expanded(
                                                              child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9),
                                                                  elevation: 3,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        e['nv'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ),
                                                    );
                                                  })
                                                ],
                                              )
                                            ]),
                                          ));
                                        }
                                        return RadiologySelectWidget(
                                          state: 2,
                                          selected:
                                              Provider.of<PharmacyController>(
                                                      context,
                                                      listen: false)
                                                  .accepted
                                                  .where((e) =>
                                                      element['id'] == e!['id'])
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

      ///
      ///To Do: remove this false with request.seen==null
      ///
      bottomNavigationBar: recieved!=null?  (  recieved!.is_seen==null) ||
              (recieved != null 
                  && recieved.is_seen== false
                  )
          ? Padding(
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
                              Provider.of<PharmacyController>(context,
                                      listen: false)
                                  .accept(recieved!.id,
                                      reject: '', type: 'radiology');
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
                          if (Provider.of<PharmacyController>(context,
                                  listen: false)
                              .labValidate()) {
                            Provider.of<provider>(context, listen: false)
                                .changePhase(2);
                          } else {
                            Toast.show('msg');
                          }

                          break;
                        case 2:
                          Provider.of<PharmacyController>(context,
                                  listen: false)
                              .accept(recieved!.id, type: 'lab')
                              .then((value) {
                            Navigator.of(context).pop();
                          });

                          break;
                        default:
                      }
                    },
                  )
                ],
              ),
            ): Container(
              height: 1,
            ): Container(height: 1,)
          
    );
  }
}

class RadiologySelectWidget extends StatefulWidget {
  final dynamic e;
  bool selected;
  int state;
  int? index;
  String? description;
  File? image;
  RadiologySelectWidget({
    required this.selected,
    required this.state,
    required this.e,
    this.description,
    this.image,
    this.index,
    super.key,
  });

  @override
  State<RadiologySelectWidget> createState() => _RadiologySelectWidgetState();
}

class _RadiologySelectWidgetState extends State<RadiologySelectWidget> {
  int minIndex = 0;
  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case 0:
        return Container(
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              Provider.of<PharmacyController>(context, listen: false)
                  .addLabToSelected(widget.e.id, name: widget.e.labtest_name);
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
                      Text(widget.e.labtest_name),
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
          // height: MediaQuery.of(context).size.height * 0.06,
          child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 3,
              child: Column(
                children: [
                  LabSubTest(
                    e: widget.e,
                    index: widget.index,
                  )
                ],
              )),
        );
      case 2:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.070,
          child: Stack(
            children: [
              Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.040,
                            child: Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.white,
                              child: Center(child: Text(widget.e['name'])),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              child: Material(
                                color: Colors.white,
                                elevation: 1,
                                borderRadius: BorderRadius.circular(9),
                                child: Center(
                                  child: Text(widget.e['resault']),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              child: Material(
                                  color: Colors.white,
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(9),
                                  child: Center(child: Text(widget.e['nv']))),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: GestureDetector(
                  onTap: () {
                    if (widget.selected) {
                      Provider.of<PharmacyController>(context, listen: false)
                          .removeLabFromAccepted(widget.index!);
                    } else {
                      Provider.of<PharmacyController>(context, listen: false)
                          .addLabToAccepted(widget.index!);
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
          ),
        );
      default:
        return Container();
    }
  }

  Future BottomSheet(BuildContext context, {required int index}) async {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return RadiologyBottomSheet(index);
      },
    );
  }
}

class RadiologyBottomSheet extends StatefulWidget {
  final int index;
  const RadiologyBottomSheet(
    this.index, {
    super.key,
  });

  @override
  State<RadiologyBottomSheet> createState() => _RadiologyBottomSheetState();
}

class _RadiologyBottomSheetState extends State<RadiologyBottomSheet> {
  bool isLoading = false;
  List images = [];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33), color: Colors.white),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Color(0xff0199EC))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                Provider.of<PharmacyController>(context).selected[widget.index]
                    ['name'],
                style: TextStyle(fontFamily: 'neo', fontSize: 20),
              )),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF7227F),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF7227F),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: images.length == 0 ? 1 : 0.8,
                  viewportFraction: images.length == 0 ? 0.99 : 0.8),
              items: [
                ...images.map((e) => Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(e),
                    )),
                GestureDetector(
                  onTap: () async {
                    XFile? image = await ImagePicker.platform
                        .getImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        images.add(File(image.path));
                      });
                    }
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    child: Center(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffF1F4FA).withOpacity(0.6),
                              ),
                              shape: BoxShape.circle),
                          child: SvgPicture.asset('assets/images/image.svg')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SubmitButtons(
                isLoading: isLoading,
                color: 0xffED1852,
                text: 'Cancel',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('cancel?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('no')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'yes',
                                  style: TextStyle(
                                    color: Color(0xffED1852),
                                  ),
                                ))
                          ],
                        );
                      }).then((value) {
                    if (value) {
                      if (value != null) {
                        Navigator.of(context).pop();
                      }
                    }
                  });
                },
              ),
              SubmitButtons(
                isLoading: isLoading,
                color: 0xff0199EC,
                text: 'Check',
                onTap: () {
                  Provider.of<PharmacyController>(context, listen: false)
                      .addImageToAccepted(images, widget.index);
                  Provider.of<PharmacyController>(context, listen: false)
                      .addDescriptionToAccepted(_controller.text, widget.index);
                  Navigator.of(context).pop('next');
                },
              )
            ],
          ),
          Container(
            height: 40,
          )
        ]));
  }
}

class LabSubTest extends StatefulWidget {
  LabSubTest({
    super.key,
    required this.e,
    required this.index,
  });
  final e;
  final index;
  int minIndex = -1;

  @override
  State<LabSubTest> createState() => _LabSubTestState();
}

class _LabSubTestState extends State<LabSubTest> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.e['name']),
      children: [
        ...Provider.of<PharmacyController>(context)
            .selected[widget.index!]['content']
            .map((e) {
          widget.minIndex += 1;
          return LabSimWidget(
            widget: widget,
          );
        }),
        IconButton(
          onPressed: () {
            Provider.of<PharmacyController>(context, listen: false)
                .addLabTest(widget.index);
          },
          icon: Icon(Icons.add),
          color: Colors.blue,
        ),
      ],
    );
  }
}

class LabSimWidget extends StatelessWidget {
  const LabSimWidget({
    super.key,
    required this.widget,
  });

  final LabSubTest widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 45,
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(9),
              child: TextField(
                onChanged: (e) {
                  Provider.of<PharmacyController>(context, listen: false)
                      .changeLabTestName(e, widget.index!, widget.minIndex);
                },
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Test name'),
              ),
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        Row(
          children: [
            Container(
              width: 5,
            ),
            Expanded(
              child: Container(
                height: 45,
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(9),
                  child: TextField(
                    onChanged: (e) {
                      Provider.of<PharmacyController>(context, listen: false)
                          .changeLabResualt(e, widget.index!, widget.minIndex);
                    },
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Resualt'),
                  ),
                ),
              ),
            ),
            Container(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 45,
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(9),
                  child: TextField(
                    onChanged: (e) {
                      Provider.of<PharmacyController>(context, listen: false)
                          .changeLabNV(e, widget.index!, widget.minIndex);
                    },
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'N/V'),
                  ),
                ),
              ),
            ),
            Container(
              width: 5,
            ),
          ],
        ),
      ],
    );
  }
}
