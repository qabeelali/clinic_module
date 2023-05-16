import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../controller/pahrmacy_controller.dart';
import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../helper/my_appbar.dart';
import '../model/pharmacy_model.dart';
import '../model/sheet.dart';
import '../utils/props.dart';
import '../widget/pharmacy_widget.dart';

class PahrmacyLayout extends StatefulWidget {
  const PahrmacyLayout({super.key});

  @override
  State<PahrmacyLayout> createState() => _PahrmacyLayoutState();
}

class _PahrmacyLayoutState extends State<PahrmacyLayout> {
  ToastContext toastContext = ToastContext();
  TextEditingController controller = TextEditingController();
  String _controller = '';

  @override
  void initState() {
    toastContext.init(context);
    // TODO: implement initState
    super.initState();

    Provider.of<PharmacyController>(context, listen: false)
        .getSheets()
        .catchError((e) {
      Toast.show(e.toString(), duration: toastDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    List<PharmacyItem?>? sheets =
        Provider.of<PharmacyController>(context).items;

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
          child: MyAppbar(
            title: arguments['name'],
            isElevated: 1.0,
            opacity: 1.0,
            leading: true,
          ),
          preferredSize: Size(_width, _height * 0.0615)),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  child: TextField(
                    controller: controller,
                    onChanged: (e) {
                      setState(() {
                        _controller = e;
                      });
                      Provider.of<PharmacyController>(context, listen: false)
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
                                  Provider.of<PharmacyController>(context,
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
                sheets == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LaunchScreen(),
                        ],
                      )
                    : sheets.length == 0
                        ? Container()
                        : Column(
                            children: [
                              ...sheets.map((e) =>
                                  PharmacyWidget(data: e!, isSeen: e.is_seen))
                            ],
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
