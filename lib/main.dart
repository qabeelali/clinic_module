import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './controller/pahrmacy_controller.dart';
import 'controller/provider.dart';
import 'controller/ptient_controller.dart';
import 'controller/user_controller.dart';
import 'init_screen.dart';
import 'layout/Pharmacy_page.dart';
import 'layout/lab_page.dart';
import 'layout/main_page.dart';
import 'layout/other_test.dart';
import 'layout/patient.dart';
import 'layout/pharmacy.dart';
import 'layout/radiology_page.dart';
import 'layout/ultrasound.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<userController>(
          create: (_) => userController(),
        ),
        ChangeNotifierProvider<PharmacyController>(
            create: (_) => PharmacyController()),
        ChangeNotifierProvider<PatientController>(
            create: ((_) => PatientController())),
        ChangeNotifierProvider<provider>(
          create: ((_) => provider()),
        ),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/init',
      routes: {
        '/': (context) => MainPage(),
        '/patient': (context) => PatientScreen(),
        '/phramacy': (context) => PahrmacyLayout(),
        '/init': (context) => InitScreen(),
        '/pharmacy_sheet': (context) => PharmacyPage(),
        '/radiology': (context) => RadiologyPage(),
        '/lab': (context) => LabPage(),
        '/ultrasound': (context) => UltrasoundPage(),
        '/other': (context) => OtherTestPage()
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => MainPage());
          default:
            return MaterialPageRoute(builder: (context) => MainPage());
        }
      },
      title: 'clinic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
