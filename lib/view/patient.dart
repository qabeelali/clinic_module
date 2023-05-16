import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../model/sheet.dart';
import '../widget/patient_tab_child.dart';

class PatientTap extends StatefulWidget {
  PatientTap({super.key});

  @override
  State<PatientTap> createState() => _PatientTapState();
}

class _PatientTapState extends State<PatientTap> {
  String _controller = '';
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientController>(context, listen: false).getSheets();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (Provider.of<PatientController>(context, listen: false)
                .sheetsNextPageUrl !=
            null) {
          Provider.of<PatientController>(context, listen: false).getSheets(
              url: Provider.of<PatientController>(context, listen: false)
                  .sheetsNextPageUrl);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Sheet?>? sheets = Provider.of<PatientController>(context).sheets;

    return Material(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      elevation: 2,
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<PatientController>(context, listen: false)
              .getSheets();
        },
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: TextField(
                  controller: controller,
                  onChanged: (e) {
                    setState(() {
                      _controller = e;
                    });
                    Provider.of<PatientController>(context, listen: false)
                        .getSheets(search: e);
                  },
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'neo',
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xfff7227f),
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.only(left: 20),
                      prefixIcon: _controller == ''
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller = '';
                                  controller.clear();
                                  FocusScope.of(context).unfocus();
                                });
                                Provider.of<PatientController>(context,
                                        listen: false)
                                    .getSheets(search: '');
                              },
                              icon: Icon(Icons.close_outlined),
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                            ),
                      prefixIconColor: Color(0xff707070)),
                ),
              ),
            ),
            sheets == null
                ? LaunchScreen()
                : sheets.length == 0
                    ? Container()
                    : Column(
                        children: [
                          ...sheets.map((e) {
                            return PatientTabChild(data: e!);
                          })
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
