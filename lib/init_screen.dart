import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import 'controller/pahrmacy_controller.dart';
import 'controller/ptient_controller.dart';
import 'controller/user_controller.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final channel2 = MethodChannel('com.example.myChannel');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const MethodChannel channel = MethodChannel('com.example.myChannel');
    channel.setMethodCallHandler((MethodCall call) {
      if (call.method == 'receiveParameter') {
        dynamic parameter = call.arguments;
        pushToType(parameter);
      }
      return Future(() => null);
    });
  }

  Future<void> handleParameter(dynamic parameter) async {
    // Handle the received parameter here
    print('Received parameter from iOS: $parameter');
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
      Navigator.of(context)
          .pushNamed(e['route'], arguments: {'name': e['name']});
    }
  }

  @override
  Widget build(BuildContext context) {
    const List buttons = [
      {
        'name': 'doctor',
        'route': '/',
        'type': 2,
        'token': '639|ykMizlvDLhsN0ri1sgHSX933THg70wbb0rxj21th',
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              channel2.invokeMethod('popFlutterApp');
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
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
