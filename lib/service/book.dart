// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../controller/ptient_controller.dart';

// class bookService {
//   static Uri yearUrl = Uri.parse(
//       'https://web.azu-app.com/api/month-calender?date=${DateFormat.y().format(DateTime.now())}/1/2');
//   static Uri dayUrl(String day, String month) {
//     return Uri.parse(
//         'https://web.azu-app.com/api/day-calender?date=2023/$month/$day');
//   }
//   // var data;

//   static Future<Map<String, dynamic>> getYear(context) async {
//     try {
//       http.Response response = await http.get(yearUrl, headers: {
//         'Authorization':
//             'Bearer ${Provider.of<PatientController>(context, listen: false).token}',
//         'Accept': 'application/json'
//       });
//       Map<String, dynamic> data = jsonDecode(response.body);
//       return {
//         'status': true,
//         'data': data,
//       };
//     } catch (e) {
//       return {'status': false, 'message': 'error has been eccured'};
//     }
//   }

//   static Future<Map<String, dynamic>> getDay(
//       String day, String month, context) async {
//     try {
//       http.Response response = await http.get(dayUrl(day, month), headers: {
//         'Authorization':
//             'Bearer ${Provider.of<PatientController>(context, listen: false).token}',
//       });
//       Map<String, dynamic> data = jsonDecode(response.body);
//       return {
//         'status': true,
//         'data': data,
//       };
//     } catch (e) {
//       return {'status': false, 'message': 'error has been eccured'};
//     }
//   }
// }
