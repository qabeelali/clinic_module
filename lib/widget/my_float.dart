import 'dart:ffi';
import 'dart:ui';

import '../controller/ptient_controller.dart';
import '../layout/add_patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MyFloat extends StatefulWidget {
  final bool editable;
  final Offset offset;
  const MyFloat({super.key, required this.editable, required this.offset});
  @override
  _MyFloatState createState() => _MyFloatState();
}

class _MyFloatState extends State<MyFloat> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _pos;
  late Animation<double> _posY;
  late Offset _offset;
  bool open = false;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _offset = widget.offset;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    _animation =
        Tween<double>(begin: 80.0, end: MediaQuery.of(context).size.width * 0.8)
            .animate(_controller);
    _pos = Tween<double>(
            begin: _offset.dx,
            end: (MediaQuery.of(context).size.width / 2) -
                ((MediaQuery.of(context).size.width * 0.8) / 2))
        .animate(_controller);
    _posY =
        Tween<double>(begin: _offset.dy - 80, end: _offset.dy.clamp(80, 300))
            .animate(_controller);
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Positioned(
            left: _pos.value != 0 ? _pos.value : _offset.dx,
            top: open ? _posY.value : _offset.dy - 80,
            child: Draggable(
              // affinity: Axis.horizontal,
              feedback: Container(
                width: _animation.value * 0.8,
                height: _animation.value * 0.8,
                decoration: BoxDecoration(
                  color: open
                      ? Color.fromARGB(0, 250, 249, 249)
                      : Color.fromARGB(255, 255, 255, 255),
                  shape: !open ? BoxShape.circle : BoxShape.rectangle,
                  border: !open
                      ? Border.all(
                          color: Color(0xffD2D2D2),
                          width: 3,
                          style: BorderStyle.solid)
                      : null,
                  boxShadow: !open
                      ? [
                          BoxShadow(
                              color: Color(0xff454545).withOpacity(0.55),
                              offset: Offset(0, 4),
                              spreadRadius: 0.3,
                              blurRadius: 15)
                        ]
                      : null,
                  borderRadius: open ? BorderRadius.circular(20) : null,
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: !open ? 0 : 1, sigmaY: !open ? 0 : 1),
                      child: !open
                          ? Icon(
                              Icons.add_outlined,
                              color: Color(0xff0199ec),
                              size: 40,
                            )
                          : Container(
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            ),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(),
              child: GestureDetector(
                onTap: () async {
                  if (!open) {
                    _controller.forward();
                    await Future.delayed(Duration(milliseconds: 100));

                    setState(() {
                      open = true;
                    });
                  } else {
                    _controller.reverse();
                    await Future.delayed(Duration(milliseconds: 10));
                    setState(() {
                      open = false;
                    });
                  }
                },
                child: Container(
                  width: _animation.value,
                  height: _animation.value,
                  decoration: BoxDecoration(
                    color: open
                        ? Color.fromARGB(0, 250, 249, 249)
                        : Color.fromARGB(255, 255, 255, 255),
                    shape: !open ? BoxShape.circle : BoxShape.rectangle,
                    border: !open
                        ? Border.all(
                            color: Color(0xffD2D2D2),
                            width: 3,
                            style: BorderStyle.solid)
                        : null,
                    boxShadow: !open
                        ? [
                            BoxShadow(
                                color: Color(0xff454545).withOpacity(0.55),
                                offset: Offset(0, 4),
                                spreadRadius: 0.3,
                                blurRadius: 15)
                          ]
                        : null,
                    borderRadius: open ? BorderRadius.circular(20) : null,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: !open ? 0 : 1, sigmaY: !open ? 0 : 1),
                        child: !open
                            ? Icon(
                                Icons.add_outlined,
                                color: Color(0xff0199ec),
                                size: 40,
                              )
                            : Container(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FloatItem(
                                            name: 'Radiology',
                                            image: 'R',
                                            onPressed: () async {
                                              if (widget.editable) {
                                                Provider.of<PatientController>(
                                                        context,
                                                        listen: false)
                                                    .createRadiologyContainer();
                                                _controller.reverse();
                                                await Future.delayed(
                                                    Duration(milliseconds: 10));
                                                setState(() {
                                                  open = false;
                                                });
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PatientAdd(
                                                      method: 'radiology',
                                                      user: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .patientInfo,
                                                      sheetId: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .sheetId);
                                                }));
                                              }
                                            },
                                          ),
                                          FloatItem(
                                            name: 'Dx',
                                            image: 'dx',
                                            onPressed: () {
                                              if (widget.editable) {
                                              Provider.of<PatientController>(context, listen: false).createDx();
                                                
                                              }else{
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PatientAdd(
                                                        method: 'dx',
                                                        user: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .patientInfo,
                                                        sheetId: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .sheetId);
                                                  }));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FloatItem(
                                              name: 'RX',
                                              image: 'XR',
                                              onPressed: () async {
                                                if (widget.editable) {
                                                  Provider.of<PatientController>(
                                                          context,
                                                          listen: false)
                                                      .createRx();
                                                  _controller.reverse();
                                                  await Future.delayed(Duration(
                                                      milliseconds: 10));
                                                  setState(() {
                                                    open = false;
                                                  });
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PatientAdd(
                                                        method: 'rx',
                                                        user: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .patientInfo,
                                                        sheetId: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .sheetId);
                                                  }));
                                                }
                                              },
                                            ),
                                            FloatItem(
                                              name: 'ultrasound',
                                              image: 'ultrasound',
                                              onPressed: () async {
                                                if (widget.editable) {
                                                  Provider.of<PatientController>(
                                                          context,
                                                          listen: false)
                                                      .createUltrasoundContainer();
                                                  _controller.reverse();
                                                  await Future.delayed(Duration(
                                                      milliseconds: 10));
                                                  setState(() {
                                                    open = false;
                                                  });
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PatientAdd(
                                                        method: 'ultrasound',
                                                        user: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .patientInfo,
                                                        sheetId: Provider.of<
                                                                    PatientController>(
                                                                context,
                                                                listen: false)
                                                            .sheet!
                                                            .sheetId);
                                                  }));
                                                }
                                              },
                                            )
                                          ]),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FloatItem(
                                            name: 'Other tests',
                                            image: 'other-test',
                                            onPressed: () async {
                                              if (widget.editable) {
                                                Provider.of<PatientController>(
                                                        context,
                                                        listen: false)
                                                    .createOtherContainer();
                                                _controller.reverse();
                                                await Future.delayed(
                                                    Duration(milliseconds: 10));
                                                setState(() {
                                                  open = false;
                                                });
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PatientAdd(
                                                      method: 'other',
                                                      user: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .patientInfo,
                                                      sheetId: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .sheetId);
                                                }));
                                              }
                                            },
                                          ),
                                          FloatItem(
                                            name: 'Lab',
                                            image: 'drugs',
                                            onPressed: () async {
                                              if (widget.editable) {
                                                Provider.of<PatientController>(
                                                        context,
                                                        listen: false)
                                                    .createLabTestConatiner();
                                                _controller.reverse();
                                                await Future.delayed(
                                                    Duration(milliseconds: 10));
                                                setState(() {
                                                  open = false;
                                                });
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PatientAdd(
                                                      method: 'lab',
                                                      user: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .patientInfo,
                                                      sheetId: Provider.of<
                                                                  PatientController>(
                                                              context,
                                                              listen: false)
                                                          .sheet!
                                                          .sheetId);
                                                }));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                if (offset.dx >= 0 &&
                    offset.dy >= 0 &&
                    offset.dx <= (MediaQuery.of(context).size.width - 50) &&
                    offset.dy <=
                        (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * 0.0615)) {
                  setState(() {
                    _offset = offset;
                  });
                }
                if (offset.dx < 0) {
                  setState(() {
                    _offset = Offset(-45.0, offset.dy);
                  });
                }
                if (offset.dy < MediaQuery.of(context).size.height * 0.0615) {
                  setState(() {
                    _offset = Offset(
                        offset.dx, MediaQuery.of(context).size.height * 0.0615);
                  });
                }
                if (offset.dx > (MediaQuery.of(context).size.width - 50)) {
                  setState(() {
                    _offset = Offset(
                        (MediaQuery.of(context).size.width - 50), offset.dy);
                  });
                }

                if (offset.dy >
                    (MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height * 0.1215))) {
                  setState(() {
                    _offset = Offset(
                        offset.dx,
                        MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height * 0.1215));
                  });
                }
              },
            ),
          );
        });
  }
}

class FloatItem extends StatelessWidget {
  const FloatItem({
    super.key,
    required this.name,
    required this.image,
    required this.onPressed,
  });
  final String name;
  final String image;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xfff7227f),
              ),
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/${image}.svg',
                width: 100,
              ),
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        GestureDetector(
            onTap: onPressed,
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'neo',
                  fontWeight: FontWeight.w600),
            ))
      ],
    );
  }
}
