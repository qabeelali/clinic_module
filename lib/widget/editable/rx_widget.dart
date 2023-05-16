import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../controller/ptient_controller.dart';
import '../../helper/launch_screen.dart';
import '../../model/sheet.dart';

class RxWidget extends StatefulWidget {
  const RxWidget({super.key});

  @override
  State<RxWidget> createState() => _RxWidgetState();
}

class _RxWidgetState extends State<RxWidget> {
  @override
  Widget build(BuildContext context) {
    List<Rx?> rx = Provider.of<PatientController>(context).sheetToSend!.rx!;
    bool show = false;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 01, 0, 65),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: Color(0xff000000).withOpacity(0.2)),
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
                      'Rx',
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
                                  .removeRx(context);
                            },
                            child: SvgPicture.asset('assets/images/undo.svg'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                ...rx.map(
                  (e) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Material(
                              borderRadius: BorderRadius.circular(9),
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      e!.drug_name,
                                      style: TextStyle(
                                          fontFamily: 'neo', fontSize: 16),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Provider.of<PatientController>(context,
                                                listen: false)
                                            .removeRxItem(e.id);
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
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Material(
                              borderRadius: BorderRadius.circular(9),
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(e.count),
                              ),
                            ),
                          ),
                        ))
                      ],
                    );
                  },
                ),
                Container(height: 10),
                GestureDetector(
                  onTap: () {
                    BottomSheet(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('add Drug'), Icon(Icons.add)],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
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
        return AddDrugs();
      },
    );
  }
}

class AddDrugs extends StatefulWidget {
  String? type;
  AddDrugs({
    this.type,
    super.key,
  });

  @override
  State<AddDrugs> createState() => _AddDrugsState();
}

class _AddDrugsState extends State<AddDrugs> {
  ScrollController _controller = ScrollController();
  TextEditingController _testName = TextEditingController();
  TextEditingController _testDescription = TextEditingController();

  String count = '';
  bool isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientController>(context, listen: false)
        .searchDrugs(pag: false, type: widget.type);

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        Provider.of<PatientController>(context, listen: false)
            .searchDrugs(pag: true, type: widget.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                widget.type == 'ultrasound' || widget.type == 'other'
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
            children: widget.type == 'ultrasound' || widget.type == 'other'
                ? [
                    Text(
                      widget.type == null
                          ? 'Add Drug'
                          : widget.type == 'radiology'
                              ? 'Add Radiology'
                              : widget.type == 'ultrasound'
                                  ? 'add Ultrasound'
                                  : 'add Lab Test',
                      style: TextStyle(fontSize: 25, fontFamily: 'neo'),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 30,
                        ),
                        Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _testName,
                              decoration: InputDecoration(
                                  hintText: 'test name',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff0199EC))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff0199EC)))),
                            )),
                        Container(
                          height: 30,
                        ),
                        Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _testDescription,
                              maxLines: 8,
                              decoration: InputDecoration(
                                  hintText: 'Description',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff0199EC))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff0199EC)))),
                            )),
                        Container(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                if (widget.type == 'ultrasound') {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .addUltrasound(Ultrasound(
                                          description_note:
                                              _testDescription.text,
                                          received_note: '',
                                          id: 0,
                                          name: _testName.text,
                                          isAccepted: 0,
                                          file_url: []));
                                } else {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .addOther(Other(
                                          id: 0,
                                          name: _testName.text,
                                          description_note:
                                              _testDescription.text,
                                          isAccepted: 0,
                                          file_url: []));
                                }
                                print(Provider.of<PatientController>(context,
                                        listen: false)
                                    .sheetToSend);
                                Navigator.of(context).pop();
                              },
                              child: Text('add test')),
                        )
                      ],
                    ),
                  ]
                : [
                    Column(
                      children: [
                        Text(
                          widget.type == null
                              ? 'Add Drug'
                              : widget.type == 'radiology'
                                  ? 'Add Radiology'
                                  : widget.type == 'ultrasound'
                                      ? 'add Ultrasound'
                                      : 'add Lab Test',
                          style: TextStyle(fontSize: 25, fontFamily: 'neo'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Provider.of<PatientController>(context)
                                        .selectedDrug !=
                                    null
                                ? Expanded(
                                    flex: 2,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(9),
                                      elevation: 3,
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                Provider.of<PatientController>(
                                                        context)
                                                    .selectedDrug!
                                                    .name,
                                                style: TextStyle(
                                                    fontFamily: 'neo'),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    Provider.of<PatientController>(
                                                            context,
                                                            listen: false)
                                                        .removeDrug();
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/images/undo.svg'))
                                            ],
                                          ))),
                                    ),
                                  )
                                : DrugTextField(
                                    error: false,
                                    flex: 2,
                                    label: 'Drug Name',
                                    onChanged: (e) {
                                      Provider.of<PatientController>(context,
                                              listen: false)
                                          .searchDrugs(
                                              drug: e,
                                              pag: false,
                                              type: widget.type);
                                    },
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            widget.type == null
                                ? DrugTextField(
                                    error: isError,
                                    flex: 1,
                                    label: 'Count',
                                    type: TextInputType.number,
                                    onChanged: (e) {
                                      setState(() {
                                        count = e;
                                      });
                                    },
                                  )
                                : Container()
                          ],
                        )
                      ],
                    ),
                    Expanded(
                        child: ListView(
                      controller: _controller,
                      shrinkWrap: true,
                      children: Provider.of<PatientController>(
                        context,
                      ).drugs.isEmpty
                          ? [LaunchScreen()]
                          : [
                              ...Provider.of<PatientController>(
                                context,
                              ).drugs.map((e) => DrugSearchWidget(
                                    drug: e!,
                                  ))
                            ],
                    )),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          if (count != '' || widget.type != null) {
                            switch (widget.type) {
                              case 'radiology':
                                Provider.of<PatientController>(context,
                                        listen: false)
                                    .addRadiology(count);

                                break;
                              case 'lab':
                                Provider.of<PatientController>(context,
                                        listen: false)
                                    .addLabTest();
                                break;
                            }
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .addDrug(count);
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              isError = true;
                            });
                          }
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                            child: Text(
                              'add',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
          ),
        ),
      ),
    );
  }
}

class DrugSearchWidget extends StatelessWidget {
  const DrugSearchWidget({
    required this.drug,
    super.key,
  });

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(drug.name),
        selected: Provider.of<PatientController>(context).selectedDrug != null
            ? Provider.of<PatientController>(context).selectedDrug!.id ==
                drug.id
            : false,
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Provider.of<PatientController>(context, listen: false)
              .selectDrug(drug);
        },
      ),
    );
  }
}

class DrugTextField extends StatelessWidget {
  DrugTextField({
    required this.flex,
    required this.label,
    this.onChanged,
    this.type,
    required this.error,
    super.key,
  });
  final int flex;
  final String label;
  Function(String)? onChanged;
  bool error;
  TextInputType? type;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextField(
            onChanged: onChanged,
            keyboardType: type ?? TextInputType.text,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: error ? Colors.red : null),
              labelText: label,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: error ? Colors.red : Colors.grey),
                  borderRadius: BorderRadius.circular(20)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ));
  }
}
