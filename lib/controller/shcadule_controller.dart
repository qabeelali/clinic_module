import 'dart:convert';

import '../model/schadule.dart';
import '../utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;

class SchaduleController extends ChangeNotifier {
  init() {
    currentDay = currentDate.day;
    currentMonth = currentDate.month;
    currentYear = currentDate.year;
    dateString = '$currentYear/$currentMonth/$currentDay';
    currentMonthString = months[currentMonth - 1];
    print(currentMonthString);
  }
  List days = []; 
  List <OrderContainer>? orders = [];
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  DateTime currentDate = DateTime.now();
  late int currentDay;
  late int currentMonth;
  late int currentYear;
  late String dateString;
  late String currentMonthString;
  bool isMonthOpen = false;

  void setMonthOpen() {
    isMonthOpen = true;
    notifyListeners();
  }

  void setNewMonth(int index) {
    currentMonth = index;
    isMonthOpen = false;
    currentMonthString  = months[index-1];
     
    dateString = '$currentYear/$currentMonth/$currentDay';
    
    notifyListeners();
  getDays();
  getOrders();
  }

  void setDay (int index){
       currentDay = index;
    dateString = '$currentYear/$currentMonth/$currentDay';
    
       notifyListeners();
       getOrders();
  }

  Future<void>getDays()async{
      days = [];

    http.Response _res = await http.get(Uri.parse(getDaysUrl(dateString)));

    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);
      if (json['status']) {
      days = json['data']['days'];
      }
      notifyListeners();
    }
  }
  Future <void> getOrders()async {
    orders  = null;
       http.Response _res = await http.get(Uri.parse(getOrdersUrl(dateString)));
      

    if (_res.statusCode == 200) {
      orders = [];
      var json = jsonDecode(_res.body);
      print(json['data']);
      if (json['status']) {
      for (var element in json['data']) {
        orders!.add(OrderContainer.fromJson(element));
      }
      }
    }
    notifyListeners();
  }
}
