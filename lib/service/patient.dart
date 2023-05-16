// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class Patient {
//   static Uri url = Uri.parse('http://192.168.0.114/api/sheets');
// static Uri singleSheetUrl(int id){
//   return Uri.parse('http://192.168.0.114/api/sheets/show?id=$id');
// }



//   static Future<Map> getPatients() async {
//     http.Response response = await http.get(url, headers: {
//       'Authorization': 'Bearer 1604|huHd3KdUZm3zIYBqRlFkC7b8SjFgUFRcNzAutFTj',
//       "Accept": "application/json"
//     });

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       try {
//         return jsonDecode(response.body);
//       } catch (e) {
//         print('Error parsing JSON data: $e');
//         return {};
//       }
//     } else {
//       print('Error retrieving data from API: ${response.statusCode}');
//       return {};
//     }
//   }
// static Future getSinlgeSheet(int id)async{
//  http.Response _res = await http.get(singleSheetUrl(id), headers: {
//           'Authorization': 'Bearer 1604|huHd3KdUZm3zIYBqRlFkC7b8SjFgUFRcNzAutFTj',
//       "Accept": "application/json"
//   });

//   return jsonDecode(_res.body);
// }

// }
