import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class provider extends ChangeNotifier {
  int phase = 0;

  bool makeVisible = false;
  String month = DateFormat.MMMM().format(DateTime.now()).trim();
  String? selectedMonth;
  double scrollLevel = 0;
  String selectedDay = DateFormat.d().format(DateTime.now()).trim();
  int currentMonth = DateTime.now().month;
  bool isPatientWidgetClicable = true;
  ScrollController controller = ScrollController();
  showMonths() {
    makeVisible = true;
    notifyListeners();
  }

  choseMonth(String month, index) {
    selectedMonth = month;
    selectedDay = '1';
    makeVisible = false;
    currentMonth = index;
    controller.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 300));
    notifyListeners();
  }

  startDayScroll() {
    controller.animateTo(
        double.parse(DateFormat.d().format(DateTime.now()).trim()) * 23,
        curve: Curves.linear,
        duration: Duration(milliseconds: 300));
    notifyListeners();
  }

  setDay(String day) {
    selectedDay = day;
    notifyListeners();
  }

  makeLevel(double offset) {
    scrollLevel = offset;
  }

  changePatientSheetClickablety(bool state) {
    isPatientWidgetClicable = state;
    notifyListeners();
  }

  changePhase(int number) {
    phase = number;
    notifyListeners();
  }

  downPhase() {
    phase -= 1;
    notifyListeners();
  }
}
