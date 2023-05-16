import 'package:flutter/material.dart';
import 'package:flutter_nps/layout/add_patient.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';

import '../helper/my_appbar.dart';
import '../view/patient.dart';
import '../view/received.dart';
import '../widget/tabbar_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ToastContext toastContext = ToastContext();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastContext.init(context);
  }

  int selectedTab = 0;
  double opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    List tabs = [
      {
        'name': 'Patient',
        'widget': PatientTap(),
        'index': 0,
        'color': Color(0xff0199EC),
      },
      // {
      //   'name': 'Schadule',
      //   'widget': Schadule(),
      //   'index': 1,
      //   'color': Color(0xffF7227F)
      // },
      {
        'name': 'Recieved',
        'widget': ReceivedScreen(),
        'index': 1,
        'color': Color(0xff0199EC)
      }
    ];
    return DefaultTabController(
      initialIndex: selectedTab,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            child: MyAppbar(
              title: tabs[selectedTab]['name'],
              isElevated: 1.0,
              opacity: opacity,
              leading: true,
              actions: [
                selectedTab == 0
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PatientAdd();
                          }));
                        },
                        icon: SvgPicture.asset('assets/images/add_patient.svg'))
                    : Container(),
                Container(
                  width: 20,
                )
              ],
            ),
            preferredSize: Size(_width, _height * 0.0615)),
        body: Column(
          children: [
            Center(
              child: SizedBox(
                height: _height * 0.022,
                // width: _width*0.,
              ),
            ),
            Container(
              width: _width * 0.90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Row(
                children: [
                  ...tabs.map((e) {
                    return TabBarItem(
                      data: e['name'],
                      isSelected: e['index'] == selectedTab,
                      onTap: () async {
                        int oldIndex = selectedTab;
                        setState(() {
                          selectedTab = e['index'];
                          if (oldIndex != selectedTab) {
                            opacity = 0;
                          }
                        });
                        await Future.delayed(Duration(milliseconds: 100));
                        setState(() {
                          opacity = 1;
                        });
                      },
                      color: e['color'],
                    );
                  })
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: tabs[selectedTab]['widget'])
          ],
        ),
      ),
    );
  }
}
