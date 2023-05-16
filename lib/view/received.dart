import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/pahrmacy_controller.dart';
import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../model/pharmacy_model.dart';
import '../model/sheet.dart';
import '../widget/patient_tab_child.dart';
import '../widget/pharmacy_widget.dart';

class ReceivedScreen extends StatefulWidget {
  const ReceivedScreen({super.key});

  @override
  State<ReceivedScreen> createState() => _ReceivedState();
}

class _ReceivedState extends State<ReceivedScreen> {
  TextEditingController _controller = TextEditingController();
  String search = "";
  int selected = 0;
  List tabs = ['tests', 'sheets'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PharmacyController>(context, listen: false).getSheets();
    Provider.of<PatientController>(context, listen: false)
        .getReceivedSheets()
        .then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PharmacyItem?>? sheets =
        Provider.of<PharmacyController>(context).items;
    List<Sheet?> recievedSheets =
        Provider.of<PatientController>(context).recievedSheet;

    print(recievedSheets);
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(33),
      child: Column(
        children: [
          Container(
            height: 30,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _controller,
                onChanged: (e) {
                  setState(() {
                    search = e;
                  });
                },
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
                    prefixIcon: search == ''
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                search = '';
                              });
                            },
                            icon: Icon(
                              Icons.close,
                            ),
                            enableFeedback: false,
                            splashColor: Colors.transparent,
                            color: Color(0xffC2C2C2),
                          ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(0xffC2C2C2),
                    )),
              )),
          Container(
            height: 20,
          ),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(9),
            child: Row(
              children: [
                ...tabs.mapIndexed((index, element) => Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: AnimatedContainer(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        duration: Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index == selected
                                ? Color(0xff0199EC)
                                : Colors.white),
                        child: Center(
                          child: Text(element,
                              style: TextStyle(
                                color: selected == index
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        ),
                      ),
                    )))
              ],
            ),
          ),
          selected == 0
              ? TestsTab(sheets: sheets ?? [])
              : RecievedTab(
                  sheets: recievedSheets,
                )
        ],
      ),
    );
  }
}

class TestsTab extends StatelessWidget {
  const TestsTab({
    super.key,
    required this.sheets,
  });

  final List sheets;

  @override
  Widget build(BuildContext context) {
    return sheets.isEmpty
        ? Center(
            child: LaunchScreen(),
          )
        : Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: 10,
                ),
                ...sheets.map((e) => PharmacyWidget(
                      data: e,
                      isSeen: e.is_seen,
                    ))
              ],
            ),
          );
  }
}

class RecievedTab extends StatelessWidget {
  const RecievedTab({
    super.key,
    required this.sheets,
  });

  final List sheets;

  @override
  Widget build(BuildContext context) {
    return sheets.isEmpty
        ? Center(child: LaunchScreen())
        : sheets.isEmpty
            ? Container()
            : Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 10,
                    ),
                    ...sheets.map((e) => PatientTabChild(
                          data: e,
                        ))
                  ],
                ),
              );
  }
}
