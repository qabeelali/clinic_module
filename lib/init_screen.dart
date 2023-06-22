import 'package:flutter/services.dart';
import 'package:flutter_nps/layout/patient.dart';
import 'package:flutter_nps/layout/requests.dart';

import '/controller/pahrmacy_controller.dart';
import '/controller/ptient_controller.dart';
import '/controller/shcadule_controller.dart';
import '/controller/user_controller.dart';
import '/service/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import 'layout/request.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    const MethodChannel channel = MethodChannel('com.example.myChannel');
    channel.setMethodCallHandler((MethodCall call) {
      if (call.method == 'receiveParameter') {
        dynamic parameter = call.arguments;
        pushToType(parameter);
      }
      return Future(() => null);
    });

    // TODO: implement initState
    super.initState();
    Provider.of<SchaduleController>(context, listen: false).init();
  }

  void pushToType(Map? e) {
    if (e != null) {
      Provider.of<userController>(context, listen: false)
          .login(e['token'], e['type']);

      if (e['type'] == 2) {
        Provider.of<PatientController>(context, listen: false)
            .setToken(e['token']);
        Provider.of<PharmacyController>(context, listen: false)
            .setToken(e['token']);
      } else {
        Provider.of<PharmacyController>(context, listen: false)
            .setToken(e['token']);
      }
      if (e['method'] == 'home') {
        Navigator.of(context)
            .pushNamed(e['route'], arguments: {'name': e['name']});
      } else if (e['method'] == 'notification') {
        switch (e['route']) {
          case 'sheet':
            Provider.of<PatientController>(context, listen: false)
                .getShowSheet(e['id']);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PatientScreen(),
            ));

            break;
          case 'rx':
            Provider.of<PharmacyController>(context, listen: false)
                .getRecievedData(e['id']);
            Navigator.of(context).pushNamed('/pharmacy_sheet');

            break;

          case 'lab':
            Provider.of<PharmacyController>(context, listen: false)
                .getRecievedData(e['id']);
            Navigator.of(context).pushNamed('/lab');
            break;
          case 'radiology':
            Provider.of<PharmacyController>(context, listen: false)
                .getRecievedData(e['id']);
            Navigator.of(context).pushNamed('/radiology');
            break;
          case 'ultrasound':
            Provider.of<PharmacyController>(context, listen: false)
                .getRecievedData(e['id']);
            Navigator.of(context).pushNamed('/ultrasound');
            break;
          case 'othertest':
            Provider.of<PharmacyController>(context, listen: false)
                .getRecievedData(e['id']);
            Navigator.of(context).pushNamed('/ultrasound');
            break;
          case 'clinic':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestScreen(id: e['id'])));
                break;
          default:
        }
      }
    }
    print(e);
  }
  //  {
  //   'token':token, //string
  //   'name':typeName,//string
  //   'type':type,//int
  //   ///
  //   ///routes here have no changes same routs you have
  //   ///
  //   'route':route,//string, start with "/"
  //   'method':"home"
  // }

  // {
  //   'token':token, //string
  //   'name':typeName,//string
  //   'type':type,//string
  //   ///
  //   ///routes here are:
  //   ///[rx, radiology, ultrasound, othertest, clinic]
  //   ///
  //   'route':route,//string, without "/"
  //   'method': 'notification'
  // }

  @override
  Widget build(BuildContext context) {
    const List buttons = [
      {
        'name': 'doctor',
        'route': '/',
        'type': 2,
        'token': '964|9aBZEF96vlM8f4cpdDziN6ZHJrqeCEIdZcvo30Fm',
      },
      {
        'name': 'pharmacy',
        'type': 3,
        'token': '641|x96oyN7xgdgaI0lwTrlw8Bb9o3aKZX1Z9TGnnuNa',
        'route': '/phramacy'
      },
      {
        'name': 'radiology',
        'route': '/phramacy',
        'type': 4,
        'token': '643|OeplEdMjX7xGuZOcZ3Wi1CiUUMqzBFLy5pgoVRoE'
      },
      {
        'name': 'ultrasound',
        'route': '/phramacy',
        'type': 5,
        'token': '651|4YHb2Fjy9hIxg4O2bBXPKg9bnzGEJrOilU0blLS4'
      },
      {
        'name': 'lab',
        'route': '/phramacy',
        'type': 6,
        'token': '650|w0t02E3iD3Lap2r05CbclC9ZflFkpdzwm2m10dAv'
      },
    ];

    return Scaffold(
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          direction: Axis.vertical,
          spacing: 10,
          children: [
            ...buttons.map((e) => ElevatedButton(
                onPressed: () async {
                  Provider.of<userController>(context, listen: false)
                      .login(e['token'], e['type']);

                  if (e['type'] == 2) {
                    Provider.of<PatientController>(context, listen: false)
                        .setToken(e['token']);
                    Provider.of<PharmacyController>(context, listen: false)
                        .setToken(e['token']);
                  } else {
                    Provider.of<PharmacyController>(context, listen: false)
                        .setToken(e['token']);
                  }
                  Navigator.of(context)
                      .pushNamed(e['route'], arguments: {'name': e['name']});
                },
                child: Text(e['name'])))
          ],
        ),
      ),
    );
  }
}
