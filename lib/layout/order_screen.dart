import '../main.dart';
import 'package:flutter/material.dart';

import '../helper/my_appbar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: MyAppbar(
            title: 'Patient',
            isElevated: 0.0,
            opacity: 1.0,
            leading: true,
          ),
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.0615)),
    );
  }
}
