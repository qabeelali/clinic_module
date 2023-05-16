import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../model/pharmacy_model.dart';
import '../utils/constant.dart';
import '../utils/props.dart';

class PharmacyController extends ChangeNotifier {
  List accepted = [];
  String token = '';
  List<PharmacyItem?>? items = [];
  Recieved? received;
  String? sheetsNextPageUrl;
  List selected = [];
  addToSelected(id, {name}) {
    if (selected.where((element) => element['id'] == id).isEmpty) {
      selected.add({'id': id, 'name': name});
    } else {
      selected.removeWhere((element) => element['id'] == id);
    }

    notifyListeners();
  }

  addLabToSelected(id, {name}) {
    if (selected.where((element) => element['id'] == id).isEmpty) {
      selected.add(
        {
          'id': id,
          'content': [{}],
          'name': name
        },
      );
    } else {
      selected.removeWhere((element) => element['id'] == id);
    }

    notifyListeners();
  }

  addLabTest(index) {
    selected[index]['content'].add({});
    notifyListeners();
  }

  Future<void> getSheets({String? url, String? search}) async {
    items = null;

    http.Response _res = await http
        .get(Uri.parse(url ?? showAllRecieved(search)), headers: {
      'Authorization': 'Bearer ${token}',
      "Accept": "application/json"
    });

    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);
      if (json['status'] == null) {
        sheetsNextPageUrl = json['next_page_url'];
        if (json['data'].isEmpty) {
          items = [];
        } else {
          items = [];
          for (var element in json['data']) {
            items!.add(PharmacyItem.fromJson(element));
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> getRecievedData(id) async {
    received = null;
    http.Response _res = await http.get(Uri.parse(getRecievedDataUrl(id)),
        headers: {
          'Authorization': 'Bearer ${token}',
          "Accept": "application/json"
        });
    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);

      if (json['status']) {
        received = Recieved.fromJson(json['data'][0]);
      } else {
        throw json['message'];
      }
    }
    notifyListeners();
  }

  Future<void> accept(id, {dynamic reject, required String type}) async {
    //
    //
    Map<String, dynamic> postData = reject == null
        ? {
            "data": type == 'pharmacy' || type == 'lab'
                ? [...selected]
                : [...accepted],
            "update_id": id,
          }
        : {'update_id': id};
    final postUrl = Uri.parse(reject != null ? rejectUrl : acceptUrl);

    http.Response _res = await http.post(
      postUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
        'ali': 'olp;qwekmdfolp;wqe'
      },
      body: json.encode(postData),
    );

    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);

      if (json['status']) {
        Toast.show(json['message'],
            backgroundColor: Colors.green, duration: toastDuration);
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }
    }
  }

  void setToken(String tok) {
    token = tok;
    notifyListeners();
  }

  addImageToAccepted(List images, int index) {
    selected[index]['files'] = images;
    notifyListeners();
  }

  removeImageToAccepted(int index, int imageIndex) {
    // selected[index]['files'].removeAt(index);
    notifyListeners();
  }

  addDescriptionToAccepted(String description, int index) {
    selected[index]['received_note'] = description;
    notifyListeners();
  }

  clearAccepted() {
    selected = [];
    accepted = [];
    notifyListeners();
  }

  addToAccepted(int index) {
    accepted.add({
      'id': selected[index]['id'],
      'received_note': selected[index]['received_note'],
      'files': selected[index]['files']
          .map((e) => base64Encode(e.readAsBytesSync()))
          .toList()
    });
    notifyListeners();
  }

  removeFromAccepted(int index) {
    accepted.removeWhere((element) => element['id'] == selected[index]['id']);
    notifyListeners();
  }

  Future<void> acceptTests(int id) async {
    final response = await http.post(
      Uri.parse(acceptUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'ali': 'olp;qwekmdfolp;wqe'
      },
      body: jsonEncode({
        'update_id': id,
        'data': [...accepted],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status']) {
        Toast.show(responseBody['message'],
            backgroundColor: Colors.green, duration: toastDuration);
      } else {
        Toast.show(responseBody['message'],
            backgroundColor: Colors.green, duration: toastDuration);
      }
    }
  }

  changeLabResualt(String text, int index, int subIndex) {
    selected[index]['content'][subIndex]['result'] = text;
    notifyListeners();
  }

  changeLabTestName(String text, int index, int subIndex) {
    selected[index]['content'][subIndex]['name'] = text;
    notifyListeners();
  }

  changeLabNV(String text, int index, int subIndex) {
    selected[index]['content'][subIndex]['nv'] = text;

    notifyListeners();
  }

  addLabToAccepted(int index) {
    accepted.add({
      'id': selected[index]['id'],
      'result': selected[index]['result'],
      'nv': selected[index]['nv']
    });
    notifyListeners();
  }

  removeLabFromAccepted(int index) {
    accepted.removeWhere((element) => element['id'] == selected[index]['id']);
    notifyListeners();
  }
}
