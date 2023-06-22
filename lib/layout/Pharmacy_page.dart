import '../controller/pahrmacy_controller.dart';
import '../controller/provider.dart';
import '../helper/launch_screen.dart';
import '../model/pharmacy_model.dart';
import '../model/sheet.dart';
import '../widget/doctor_data_widget.dart';
import '../widget/patient_data_widget.dart';
import '../widget/pharmacy_appbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import 'add_patient.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  void initState() {
    // TODO: implement dispose
    super.initState();
    Provider.of<PharmacyController>(context, listen: false).clearAccepted();

    Provider.of<provider>(context, listen: false).changePhase(0);
  }

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
                        shrinkWrap: true,
                        children: true? [
                          if(Provider.of<provider>(context).phase==0) ...recieved.rx!.mapIndexed((index, e) {
                            if(e.isAccepted==0){
                              return  DrugPharmacyItem(
                                          selected:
                                              Provider.of<PharmacyController>(
                                                      context,
                                                      listen: false)
                                                  .selected
                                                  .where((element) =>
                                                      element['id'] ==
                                                      e.orderId)
                                                  .isNotEmpty,
                                          rx: e!,
                                          phase: 0,
                                        );
                            }
                                  return DrugPharmacyItem(
                                      selected: true,
                                      rx: e,
                                      phase: 2,
                                      seen: true);
                                  // return Container(
                                  //   height: 20,
                                  //   width: 20,
                                  //   color: Colors.black,
                                  // );
                                })
                       
                    ,   if(Provider.of<provider>(context).phase == 1) ...Provider.of<PharmacyController>(context,
                                            listen: false)
                                        .selected
                                        .mapIndexed((index, element) {
                                      return DrugPharmacyItem(
                                        selected: true,
                                        rx: element!,
                                        phase:1,
                                      );
                                    })
                        ]:  recieved.is_seen!
                            ? [
                                ...recieved.rx!.mapIndexed((index, element) {
                                  return DrugPharmacyItem(
                                      selected: true,
                                      rx: element,
                                      phase: 1,
                                      seen: true);
                                  // return Container(
                                  //   height: 20,
                                  //   width: 20,
                                  //   color: Colors.black,
                                  // );
                                })
                              ]
                            : Provider.of<provider>(context).phase == 0
                                ? [
                                    ...recieved.rx!.map((e) => DrugPharmacyItem(
                                          selected:
                                              Provider.of<PharmacyController>(
                                                      context,
                                                      listen: false)
                                                  .selected
                                                  .where((element) =>
                                                      element['id'] ==
                                                      e.orderId)
                                                  .isNotEmpty,
                                          rx: e!,
                                          phase: 0,
                                        ))
                                  ]
                                // : Provider.of<provider>(context).phase == 1
                                //     ? [
                                //         ...Provider.of<PharmacyController>(
                                //                 context)
                                //             .selected
                                //             .mapIndexed(
                                //                 (index, e) => DrugPharmacyItem(
                                //                       selected: false,
                                //                       rx: e!,
                                //                       phase: 1,
                                //                       index: index,
                                //                     ))
                                //       ]
                                : [
                                    ...Provider.of<PharmacyController>(context,
                                            listen: false)
                                        .selected
                                        .mapIndexed((index, element) {
                                      return DrugPharmacyItem(
                                        selected: true,
                                        rx: element!,
                                        phase: 1,
                                      );
                                    })
                                  ])),
              ],
            ),
      bottomNavigationBar: recieved == null ? Container(): recieved.is_seen == true
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
                    text: Provider.of<provider>(context).phase == 1
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
                          setState(() {
                            isLoading = true;
                          });
                          Provider.of<PharmacyController>(context,
                                  listen: false)
                              .accept(recieved!.id, type: 'pharmacy')
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

class DrugPharmacyItem extends StatefulWidget {
  DrugPharmacyItem({
    required this.selected,
    required this.rx,
    required this.phase,
    this.seen,
    super.key,
    this.index,
  });
  bool selected;
  final rx;
  final phase;
  final index;
  bool? seen;

  @override
  State<DrugPharmacyItem> createState() => _DrugPharmacyItemState();
}

class _DrugPharmacyItemState extends State<DrugPharmacyItem> {
  @override
  Widget build(BuildContext context) {
    switch (widget.phase) {
      case 0:
        return GestureDetector(
          onTap: () {
            Provider.of<PharmacyController>(context, listen: false)
                .addToSelected(widget.rx.orderId, name: widget.rx.drug_name);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: widget.selected
                        ? Color(0xff0199EC)
                        : Colors.transparent)),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, top: 8, bottom: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Text(
                        '${widget.rx.drug_name} Co.${widget.rx.count} ',
                        style: TextStyle(fontSize: 20, fontFamily: 'neo'),
                      ),
                    ),
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
        );
      case 1:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.seen == null
                          ? widget.rx['name']
                          : widget.rx.drug_name,
                      style: TextStyle(fontSize: 18, fontFamily: 'neo'),
                    ),
                  )),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: widget == null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Material(
                              color: Colors.white,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(widget.seen == null
                                        ? ''
                                        : widget.rx.description)),
                              )),
                        )
                      : TextField(
                          onChanged: (e) {
                            Provider.of<PharmacyController>(context,
                                    listen: false)
                                .addDescriptionToAccepted(e, widget.index);
                          },
                          maxLines: 4,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: BorderSide(
                                color: Color(0xff0199EC),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: BorderSide(
                                color: Color(0xff0199EC),
                              ),
                            ),
                          ),
                        ))
            ],
          ),
        );
      case 2:
       return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.seen == null
                          ? widget.rx['name']
                          : widget.rx.drug_name,
                      style: TextStyle(fontSize: 18, fontFamily: 'neo'),
                    ),
                  )),
                ),
              ),
              Container(
                height: 20,
              ),
            widget.rx.description == null
                                        ? Container()
                                        :  Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: widget.rx.description == null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Material(
                              color: Colors.white,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text( widget.rx.description)),
                              )),
                        )
                      : TextField(
                          onChanged: (e) {
                            Provider.of<PharmacyController>(context,
                                    listen: false)
                                .addDescriptionToAccepted(e, widget.index);
                          },
                          maxLines: 4,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: BorderSide(
                                color: Color(0xff0199EC),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: BorderSide(
                                color: Color(0xff0199EC),
                              ),
                            ),
                          ),
                        ))
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
