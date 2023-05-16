// import 'package:clinic/controller/provider.dart';
// import 'package:clinic/service/book.dart';
// import 'package:flutter/material.dart';
// import 'dart:core';
// import 'package:intl/intl.dart';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:provider/provider.dart';

// import '../widget/schaduleBuilder.dart';

// class Schadule extends StatefulWidget {
//   @override
//   State<Schadule> createState() => _SchaduleState();
// }

// class _SchaduleState extends State<Schadule> {
//   var future;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     future = bookService.getYear(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     String month = Provider.of<provider>(context).month;
//     String? selectedMonth = Provider.of<provider>(context).selectedMonth;
//     bool isMonthsShow = Provider.of<provider>(context).makeVisible;
//     String selectedDay = Provider.of<provider>(context).selectedDay;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: schaduleBuilder(
//         future: future,
//         isMonthsShow: isMonthsShow,
//         selectedMonth: selectedMonth,
//         month: month,
//         selectedDay: selectedDay,
//       ),
//     );
//   }
// }
