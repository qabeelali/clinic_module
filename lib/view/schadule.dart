import 'dart:math';

import '../controller/shcadule_controller.dart';
import '../helper/expansios_tile.dart';
import '../helper/loading.dart';
import '../layout/order_screen.dart';
import '../layout/request.dart';
import '../model/schadule.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Schadule extends StatefulWidget {
  const Schadule({super.key});

  @override
  State<Schadule> createState() => _SchaduleState();
}

class _SchaduleState extends State<Schadule> {
  bool _show = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SchaduleController>(context, listen: false)
        .getDays()
        .then((value) {
      print('object');
    });
    Provider.of<SchaduleController>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    SchaduleController _schaduleController =
        Provider.of<SchaduleController>(context);

    bool _isMonthOpen = _schaduleController.isMonthOpen;
    List<String> _months = _schaduleController.months;
    int _currentMonth = _schaduleController.currentMonth;
    String _currentMonthString = _schaduleController.currentMonthString;
    List _days = _schaduleController.days;
    int _currentDay = _schaduleController.currentDay;
    List<OrderContainer>? _orders = _schaduleController.orders;
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimatedOpacity(
              opacity: _show ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: Row(
                children: [
                  if (!_isMonthOpen)
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _show = false;
                        });

                        await Future.delayed(Duration(milliseconds: 200));
                        Provider.of<SchaduleController>(context, listen: false)
                            .setMonthOpen();
                        setState(() {
                          _show = true;
                        });
                      },
                      child: Text(_currentMonthString),
                      style: TextButton.styleFrom(primary: Colors.black),
                    )
                  else
                    ..._months.mapIndexed((i, e) => TextButton(
                        onPressed: () async {
                          setState(() {
                            _show = false;
                          });

                          await Future.delayed(Duration(milliseconds: 200));
                          Provider.of<SchaduleController>(context,
                                  listen: false)
                              .setNewMonth(i + 1);
                          setState(() {
                            _show = true;
                          });
                        },
                        child: Text(
                          e,
                          style: TextStyle(
                              color: _currentMonth == i + 1
                                  ? Colors.black
                                  : Colors.grey),
                        ))),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (_days.isNotEmpty)
                  ..._days.mapIndexed((index, element) => TextButton(
                      onPressed: () {
                        Provider.of<SchaduleController>(context, listen: false)
                            .setDay(index + 1);
                      },
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            color: index + 1 == _currentDay
                                ? Colors.black
                                : Colors.grey),
                      )))
                else
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: Loading(),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  if (_orders != null)
                   if(_orders.isNotEmpty) ..._orders.map((e) => e.orders.length > 1
                        ? ExpansionSchaduleWidget(
                        order: e
                        )
                        : SchaduleWidget(
                            order: e.orders[0]!,
                            times: [e.startTime, e.endTime],
                          ))else Column(
                            children: [
                              Container(height: 40,),
                              Center(child: SvgPicture.asset('assets/images/no_schadule.svg')),
                              Text('no sheets yet', style: TextStyle(fontSize: 20),)
                            ],
                          ) else Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height*0.7,
                            child: Loading())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SchaduleWidget extends StatelessWidget {
  SchaduleWidget({super.key, required this.order, required this.times});
  Order order;
  List<String> times;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Navigator.of(context).push(MaterialPageRoute(builder:(context) => RequestScreen(id: order.id,),));},
      child: Hero(
        tag: order.id,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        times[0],
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        times[1],
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.102,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    decoration: BoxDecoration(
                      color: Color(0xff0199EC).withOpacity(0.11),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(order.image),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              order.full_name,
                              style:
                                  TextStyle(color: Color(0xff0199EC), fontSize: 22),
                            ),
                            Text('id: ${order.id}',
                                style: TextStyle(
                                    color: Color(0xff0199EC), fontSize: 13))
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}

class ExpansionSchaduleWidget extends StatefulWidget {
  const ExpansionSchaduleWidget({
    required this.order,
    super.key});
final OrderContainer order;
  @override
  State<ExpansionSchaduleWidget> createState() =>
      _ExpasionSchaduleWidgetState();
}

class _ExpasionSchaduleWidgetState extends State<ExpansionSchaduleWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(title: 'title', leading: null, children: [...widget.order.orders.map((e) => SchaduleWidget(order: e!, times: [widget.order.startTime, widget.order.endTime]), )], order: widget.order,);
  }
}
