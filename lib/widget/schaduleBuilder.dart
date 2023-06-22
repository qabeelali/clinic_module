// import '../helper/launch_screen.dart';
// import '../service/book.dart';
// import '../widget/schadule_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';

// import '../controller/provider.dart';

// class schaduleBuilder extends StatelessWidget {
//   schaduleBuilder({
//     super.key,
//     required this.future,
//     required this.isMonthsShow,
//     required this.selectedMonth,
//     required this.month,
//     required this.selectedDay,
//   });

//   final Future<Map<String, dynamic>> future;
//   final bool isMonthsShow;
//   final String? selectedMonth;
//   final String month;
//   final selectedDay;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: future,
//         builder: (context, fut) {
//           if (fut.connectionState == ConnectionState.done) {
//             return Column(
//               children: [
//                 isMonthsShow
//                     ? monthsScrollBar(
//                         fut: fut,
//                       )
//                     : Align(
//                         alignment: Alignment.topLeft,
//                         child: TextButton(
//                             onPressed: () {
//                               Provider.of<provider>(context, listen: false)
//                                   .showMonths();
//                               print(isMonthsShow);
//                             },
//                             child: Text(
//                               selectedMonth ?? month,
//                               style: TextStyle(
//                                   fontSize: 17,
//                                   fontFamily: 'neo',
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black),
//                             ))),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.038,
//                   child: dayScrollBar(
//                     selectedMonth: selectedMonth,
//                     month: month,
//                     selectedDay: selectedDay,
//                     fut: fut,
//                   ),
//                 ),
//                 FutureBuilder(
//                     future: bookService.getDay(
//                         selectedDay,
//                         Provider.of<provider>(context).currentMonth.toString(),
//                         context),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         print(snapshot.data);
//                         List books =
//                             snapshot.data!['data']['data']['book'].toList();

//                         print(snapshot.data);
//                         return Expanded(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 20),
//                                 ...books.mapIndexed((index, e) {
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.15,
//                                               child: Center(
//                                                   child: Text(
//                                                       (index + 1).toString()))),
//                                           schaduleWidget(
//                                             id: e['request_id'].toString(),
//                                             image: e['payment_image'],
//                                             name: e['full_name'],
//                                           )
//                                         ],
//                                       ),
//                                       Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Divider(
//                                             thickness: 1.2,
//                                           ))
//                                     ],
//                                   );
//                                 })
//                               ],
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     }),
//               ],
//             );
//           } else {
//             return LaunchScreen();
//           }
//         });
//   }
// }

// class dayScrollBar extends StatefulWidget {
//   const dayScrollBar(
//       {super.key,
//       required this.selectedMonth,
//       required this.month,
//       required this.selectedDay,
//       required this.fut});
//   final fut;
//   final String? selectedMonth;
//   final String month;
//   final selectedDay;

//   @override
//   State<dayScrollBar> createState() => _dayScrollBarState();
// }

// class _dayScrollBarState extends State<dayScrollBar> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.microtask(() {
//       Provider.of<provider>(context, listen: false).startDayScroll();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScrollController controller = Provider.of<provider>(context).controller;

//     return Material(
//       elevation: 2,
//       borderRadius: BorderRadius.circular(30),
//       child: SingleChildScrollView(
//         controller: controller,
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             ...widget
//                 .fut
//                 .data!['data']['data'][widget.selectedMonth ?? widget.month]
//                     ['book_count']
//                 .keys
//                 .map((e) {
//               return Container(
//                   width: 40,
//                   height: MediaQuery.of(context).size.height * 0.038,
//                   child: TextButton(
//                     onPressed: () {
//                       Provider.of<provider>(context, listen: false)
//                           .setDay(e.toString());
//                     },
//                     child: Text(
//                       e,
//                       style: TextStyle(
//                           color: widget.selectedDay == e
//                               ? Colors.black
//                               : Colors.grey,
//                           fontSize: 14),
//                     ),
//                   ));
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }

// class monthsScrollBar extends StatefulWidget {
//   const monthsScrollBar({super.key, required this.fut});
//   final fut;

//   @override
//   State<monthsScrollBar> createState() => _monthsScrollBarState();
// }

// class _monthsScrollBarState extends State<monthsScrollBar> {
//   ScrollController _controller = ScrollController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.microtask(() {
//       _controller.animateTo(
//           Provider.of<provider>(context, listen: false).scrollLevel,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.linear);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List keys = widget.fut.data!['data']['data'].keys.toList();
//     String? selectedMonth = Provider.of<provider>(context).selectedMonth;
//     return SingleChildScrollView(
//       controller: _controller,
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           ...keys.mapIndexed((index, map) {
//             return TextButton(
//                 onPressed: () {
//                   Provider.of<provider>(context, listen: false)
//                       .choseMonth(map, index + 1);
//                   Provider.of<provider>(context, listen: false)
//                       .makeLevel(_controller.offset);
//                 },
//                 child: Text(
//                   map,
//                   style: TextStyle(
//                       fontSize: 17,
//                       fontFamily: 'neo',
//                       fontWeight: FontWeight.w500,
//                       color: selectedMonth != null
//                           ? selectedMonth == map
//                               ? Colors.black
//                               : Colors.grey
//                           : Provider.of<provider>(context).month == map
//                               ? Colors.black
//                               : Colors.grey),
//                 ));
//           })
//         ],
//       ),
//     );
//   }
// }
