import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import '../controller/provider.dart';
import '../helper/launch_screen.dart';
import '../layout/add_patient.dart';
import '../utils/props.dart';
import '../view/image_screen.dart';
import '../widget/pharmacy_appbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../controller/pahrmacy_controller.dart';
import '../model/pharmacy_model.dart';
import '../model/sheet.dart';

class UltrasoundPage extends StatefulWidget {
  const UltrasoundPage({super.key});

  @override
  State<UltrasoundPage> createState() => _RadiologyPageState();
}

class _RadiologyPageState extends State<UltrasoundPage> {
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
    int phase = Provider.of<provider>(context).phase;

    return Scaffold(
      backgroundColor: Colors.white,
      body: recieved == null
          ? LaunchScreen()
          : Column(
              children: [
                PharmacyAppBar(),
                Expanded(
                    child: ListView(
                  children: recieved.is_seen==null?[
                          if (phase == 0)
                            ...recieved.ultrasound!.mapIndexed((index, e) {
                              if (e.isAccepted == 0) {
                                return RadiologySelectWidget(
                                  state: 0,
                                  e: e,
                                  selected: Provider.of<PharmacyController>(
                                          context,
                                          listen: false)
                                      .selected
                                      .where((element) => element['id'] == e.id)
                                      .isNotEmpty,
                                );
                              }
                              return RadiologySelectWidget(
                                state: 2,
                                selected: false,
                                index: index,
                                seen: true,
                                e: e,
                                image: e.file_url[0]['file'],
                                description: e.received_note,
                              );
                            }),
                            if(phase == 1)                                      ...Provider.of<PharmacyController>(
                                              context)
                                          .selected
                                          .mapIndexed((index, e) =>
                                              RadiologySelectWidget(
                                                state: 1,
                                                e: e,
                                                selected: false,
                                                index: index,
                                                image: e['files'] != null
                                                    ? e['files']
                                                    : null,
                                                description: e['received_note'],
                                              )),

                                              if(phase ==2) ...Provider.of<PharmacyController>(
                                              context,
                                              listen: false)
                                          .selected
                                          .mapIndexed((index, element) {
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

                        ]: recieved.is_seen!
                      ? [
                          ...recieved.ultrasound!.mapIndexed((index, element) {
                            String file = element.file_url[0]['file'];
                            return RadiologySelectWidget(
                              state: 2,
                              selected: true,
                              index: index,
                              e: element,
                              image: file,
                              seen: true,
                              description: element.received_note,
                            );
                          })
                        ]
                      : Provider.of<provider>(context).phase == 0
                          ? [
                              ...recieved!.ultrasound!
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
      bottomNavigationBar: recieved ==null?Container(height: 1,): recieved!.is_seen!=null&&( recieved == null || recieved.is_seen==true)
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
                                             if(Provider.of<PharmacyController>(context, listen: false).vlidate()){
Provider.of<provider>(context, listen: false)
                              .changePhase(2);}
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
                            Navigator.of(context).pop();
                          });

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
    this.image,
    this.seen,
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
              Provider.of<PharmacyController>(context, listen: false)
                  .addToSelected(widget.e.id, name: widget.e.name);
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
                      Text(widget.e.name),
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
                    child: widget.seen == null
                        ? widget.image != null
                            ? Image.file(widget.image![0])
                            : SvgPicture.asset('assets/images/image.svg')
                        : Image.network(widget.image),
                  ),
                ))
              ],
            ),
          ),
        );
      // return Container();
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
                                    child: Text(widget.seen == null
                                        ? widget.e['name']
                                        : widget.e.name),
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

class RadiologyBottomSheet extends StatefulWidget {
  final int index;
  String? text;
  List images = [];
  RadiologyBottomSheet(
    this.index, {
    this.text,
    required this.images,
    super.key,
  });

  @override
  State<RadiologyBottomSheet> createState() => _RadiologyBottomSheetState();
}

class _RadiologyBottomSheetState extends State<RadiologyBottomSheet> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text != null) {
      _controller.text = widget.text!;
      setState(() {});
    }
  }

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
                  aspectRatio: widget.images.length == 0 ? 1 : 0.8,
                  viewportFraction: widget.images.length == 0 ? 0.99 : 0.8),
              items: [
                ...widget.images.mapIndexed((index, e) => Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox.expand(
                        child: Stack(
                          children: [
                            Center(child: Image.file(e)),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.images.removeAt(index);
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                        'assets/images/undo.svg')))
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                  onTap: () async {
                    XFile? image = await ImagePicker.platform
                        .getImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        widget.images.add(File(image.path));
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
                isLoading: false,
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
                isLoading: false,
                color: 0xff0199EC,
                text: 'Check',
                onTap: () {
                  
                  if (widget.images.isNotEmpty && _controller.text.isNotEmpty) {
                    Provider.of<PharmacyController>(context, listen: false)
                        .addImageToAccepted(widget.images, widget.index);
                    Provider.of<PharmacyController>(context, listen: false)
                        .addDescriptionToAccepted(
                            _controller.text, widget.index);
                    Navigator.of(context).pop('next');
                  } else {
                    Toast.show('all fields are required',
                        duration: toastDuration);
                  }
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
