import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../model/sheet.dart';
import '../model/user_to_send.dart';
import '../utils/constant.dart';
import '../utils/props.dart';

class PatientController extends ChangeNotifier {
  String token = "";
  List cachedUpdates = [];
  SheetToSend? sheetToSend;
  List<UserToSend> usersToLink = [];
  Drug? selectedDrug;
  List<Drug?> drugs = [];
  List<Sheet?>? sheets = [];
  List<UserToSend?> usersToSend = [];
  Update? sheet;
  String? sheetsNextPageUrl;
  String? drugsNextUrl;
  List<File>? dxImages;
  List<Sheet?> recievedSheet = [];
  Future<void> getSheets({String? url, String? search}) async {
    if (search == null) {
      sheets = null;
    }
    http.Response _res = await http.get(Uri.parse(url ?? sheetsApi(search)),
        headers: {
          'Authorization': 'Bearer ${token}',
          "Accept": "application/json"
        });
    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);
      if (json['status'] == null) {
        if (!json['data'].isEmpty) {
          sheets = [];
          sheetsNextPageUrl = json['next_page_url'];

          for (var element in json['data']) {
            sheets!.add(Sheet.fromJson(element));
          }
        } else {
          sheets = [];
          Toast.show('No Patients Found', duration: toastDuration);
        }
      } else {
        Toast.show(json['message'], duration: toastDuration);
      }
    }
    notifyListeners();
  }

  Future<void> getShowSheet(String id) async {
    if (cachedUpdates
            .where((element) => element['id'] == int.parse(id))
            .length !=
        0) {
      sheet = cachedUpdates
          .firstWhere((element) => element['id'] == int.parse(id))['sheet'];
      notifyListeners();
    } else {
      sheet = null;
      notifyListeners();
      http.Response _res = await http.get(Uri.parse(showSheetUrl(id)),
          headers: {
            'Authorization': 'Bearer ${token}',
            "Accept": "application/json"
          });
      print(_res.statusCode);
      if (_res.statusCode == 200) {
        var json = jsonDecode(_res.body);
        if (json['status']) {
          sheet = Update.fromJson(json['data']);
          cachedUpdates.add({'id': int.parse(id), 'sheet': sheet});
        } else {
          Toast.show(json['message'], duration: toastDuration);
        }

        notifyListeners();
      }
    }
  }

  Future<void> getUsersToSend({required String type, search}) async {
    http.Response _res = await http.get(Uri.parse(searchToSend(type, search)),
        headers: {
          'Authorization': 'Bearer ${token}',
          "Accept": "application/json"
        });
    if (_res.statusCode == 200) {
      usersToSend = [];
      var json = jsonDecode(_res.body);
      print(json);
      if (json['status'] == null) {
        if (!json['data'].isEmpty) {
          sheetsNextPageUrl = json['next_page_url'];

          for (var element in json['data']) {
            usersToSend.add(UserToSend.fromJson(element));
          }
        } else {
          Toast.show('No Users Found', duration: toastDuration);
        }
        notifyListeners();
      } else {
        Toast.show(json['message'], duration: toastDuration);
      }
    }
  }

  Future<String> storePatient() async {
    if (sheetToSend != null) {
      http.Response _res = await http.post(Uri.parse(storeSheet),
          body: sheetToSend!.toJson(),
          headers: {
            'Authorization': 'Bearer ${token}',
            "Accept": "application/json"
          });

      // var _res = http.MultipartRequest('post', Uri.parse(storeSheet));

      // _res.fields['dx'] = ;

      if (_res.statusCode == 200) {
        var json = jsonDecode(_res.body);
        if (json['status']) {
          Toast.show(json['message'],
              backgroundColor: Colors.green, duration: toastDuration);
          return json['message'];
        } else {
          Toast.show(json['message'],
              backgroundColor: Colors.red, duration: toastDuration);

          throw json['message'];
        }
      } else {
        Toast.show('error has been occurred',
            backgroundColor: Colors.red, duration: toastDuration);

        throw 'error has been occurred';
      }
    } else {
      Toast.show('there is no sheet to send',
          backgroundColor: Colors.red, duration: toastDuration);

      throw 'there is no sheet to send';
    }
  }

  void setDxContent(String content) {
    sheetToSend!.setDxContent(content);
    notifyListeners();
  }

  void editDxFiles(String method, {File? file}) {
    sheetToSend!.editDxFiles(method, file: file);
    notifyListeners();
  }

  void addDrug(String count) async {
    sheetToSend!.addDrug(Rx(
        id: selectedDrug!.id,
        count: count,
        isAccepted: 0,
        drug_name: selectedDrug!.name,
        description: ''));
    selectedDrug = null;
    notifyListeners();
  }

  void clearDrug() {
    sheetToSend!.clearDrugs();
    notifyListeners();
  }

  void createSheetToSend(
      String patientName, int gender, String weight, Dx dx, String age,
      {List<Rx>? rx,
      int? sheetId,
      List<Radiology>? radiology,
      List<Other>? other,
      List<Ultrasound>? ultrasound,
      List<Lab>? lab}) {
    sheetToSend = SheetToSend(
        sheetId: sheetId,
        dx: dx,
        patientName: patientName,
        gender: gender,
        weight: weight,
        age: age,
        rx: rx,
        radiology: radiology,
        lab: lab,
        other: other,
        ultrasound: ultrasound);
    notifyListeners();
  }

  void changeName(String patientName) {
    sheetToSend!.patientName = patientName;
    notifyListeners();
    print(sheetToSend!.toJson());
  }

  void changeAge(String age) {
    sheetToSend!.age = age;
    notifyListeners();
  }

  void changeWeight(String weight) {
    sheetToSend!.weight = weight;
    notifyListeners();
  }

  void changeGender(int gender) {
    sheetToSend!.gender = gender;
    notifyListeners();
  }

  void removeRxItem(int id) {
    sheetToSend!.removeRx(id);
    notifyListeners();
  }

  Future<void> searchDrugs(
      {String? drug, required bool pag, String? type}) async {
    String url = '';
    if (!pag) {
      drugs = [];
    }

    if (type == 'radiology') {
      url = radiologySearch(drug);
    } else if (type == 'lab') {
      url = labSearch(drug);
    } else {
      url = drugsSearch(drug);
    }

    http.Response _res = await http
        .get(Uri.parse(!pag ? url : drugsNextUrl ?? url), headers: {
      'Authorization': 'Bearer ${token}',
      "Accept": "application/json"
    });
    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);
      if (json['status']) {
        drugsNextUrl = json['data']['next_page_url'];
        for (var element in json['data']['data']) {
          print(element);
          drugs.add(Drug.fromJson(element));
        }
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }
    }
    notifyListeners();
  }

  void selectDrug(Drug drug) {
    selectedDrug = drug;
    notifyListeners();
  }

  void removeDrug() {
    selectedDrug = null;
    notifyListeners();
  }

  void dismissSheet() {
    sheetToSend = null;
  }

  Future<dynamic> storeNewSheet() async {
    var url = Uri.parse(storeSheet);
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${token}",
      'ali': 'de'
    };
    var body = jsonEncode(sheetToSend!.toJson());

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
      if (json['status']) {
        return json['data'];
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
        throw 'error';
      }
    }
    throw 'error';
  }

  Future<void> sendSheet({required String type, required int userId}) async {
    var url = Uri.parse(sendData);
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${token}"
    };
    var body = jsonEncode({
      'type': type,
      'update_id': sheet!.id,
      'user_id': userId,
    });

    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status']) {
        Toast.show(json['message'],
            backgroundColor: Colors.green, duration: toastDuration);

        return json['data'];
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }

      throw 'error';
    }
  }

  createRx() {
    sheetToSend!.createRx();
    notifyListeners();
  }

  removeRx(context) {
    if (sheetToSend!.rx!.length == 0) {
      sheetToSend!.removeRxContainer();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('you want remove rx?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel')),
                TextButton(
                    onPressed: () {
                      sheetToSend!.removeRxContainer();
                      notifyListeners();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'remove',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            );
          });
    }
    notifyListeners();
  }

  addDxImage(XFile file) {
    sheetToSend!.addImage(File(file.path));
    notifyListeners();
  }

  Future<dynamic> sendNewUpadte() async {
    var url = Uri.parse(addUpdate);
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${token}",
      'ali': 'de'
    };
    var body = jsonEncode(sheetToSend!.toJson());

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json['status']) {
        Toast.show(json['message'],
            backgroundColor: Colors.green, duration: toastDuration);

        return json['data'];
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }
      throw 'error';
    }
  }

  void createRadiologyContainer() {
    sheetToSend!.createRadiology();
    notifyListeners();
  }

  void removeRadiologyContainer() {
    sheetToSend!.removeRadiologyContainer();
    notifyListeners();
  }

  void addRadiology(String count) {
    print(selectedDrug!.id);
    sheetToSend!.addRadiology(Radiology(
        id: selectedDrug!.id,
        description_note: count,
        received_note: null,
        user_id: null,
        isAccepted: 0,
        radiology_name: selectedDrug!.name,
        file_url: [],
        orderId: null));
    selectedDrug = null;
    notifyListeners();
  }

  void addLabTest() {
    sheetToSend!.addLab(Lab(
      id: selectedDrug!.id,
      isAccepted: 0,
      labtest_name: selectedDrug!.name,
      labtest_id: selectedDrug!.id.toString(),
    ));
    selectedDrug = null;
    notifyListeners();
  }

  void changeRadiologyDecription(
      {required String description, required int index}) {
    sheetToSend!.radiology![index].description_note = description;
    notifyListeners();
  }

  void setToken(String tok) {
    token = tok;
    notifyListeners();
  }

  void createLabTestConatiner() {
    sheetToSend!.createLabContainer();
    notifyListeners();
  }

  void removeLabTestContainer() {
    sheetToSend!.removeLabContainer();
    notifyListeners();
  }

  void removeLabTest(int id) {
    sheetToSend!.removeLab(id);
    notifyListeners();
  }

  void createUltrasoundContainer() {
    sheetToSend!.createUltrasoundContainer();
    notifyListeners();
  }

  void removeUltrasoundContainer() {
    sheetToSend!.removeUltrasoundContainer();
    notifyListeners();
  }

  void addUltrasound(Ultrasound _ultrasound) {
    sheetToSend!.addUltrasound(_ultrasound);
    notifyListeners();
  }

  void removeUltrasound(int id) {
    sheetToSend!.removeUltrasound(id);
    notifyListeners();
  }

  void createOtherContainer() {
    sheetToSend!.createOtherContainer();
    print(sheetToSend!.toJson());
    notifyListeners();
  }

  void removeOtherContainer() {
    sheetToSend!.removeOtherContainer();
    notifyListeners();
  }

  void addOther(Other _other) {
    sheetToSend!.addOther(_other);
    notifyListeners();
  }

  Future<Map?> getReceivedSheets({String? url}) async {
    recievedSheet = [];
    http.Response _res = await http.get(Uri.parse(url ?? recievedSheetUrl),
        headers: {
          'Authorization': 'Bearer ${token}',
          "Accept": "application/json"
        });
    print(_res.statusCode);
    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);
      print(_res.body);
      if (json['status'] != null) {
        sheetsNextPageUrl = json['next_page_url'];
        print(json['current_page']);

        for (var element in json['data']) {
          print(element);

          recievedSheet.add(Sheet.fromJson(element));
        }

        notifyListeners();
      }
    }
  }

  Future<dynamic> ssendSheetToDoctor() async {
    var url = Uri.parse(sendSheetToDoctor);
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${token}",
      'ali': 'de'
    };
    var body = jsonEncode(sheetToSend!.toJson());
    print(body);

    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status']) {
        Toast.show(json['message'],
            backgroundColor: Colors.green, duration: toastDuration);

        return json['data'];
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }
      throw 'error';
    }
  }

  Future<void> searchToLink(String? search) async {
    usersToLink = [];
    http.Response _res = await http.get(Uri.parse(searchToLoinkUrl(search)),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${token}"
        });
    if (_res.statusCode == 200) {
      var json = jsonDecode(_res.body);

      if (json['status']) {
        for (var element in json['data']) {
          usersToLink.add(UserToSend.fromJson(element));
        }
      } else {
        Toast.show(json['message'],
            backgroundColor: Colors.red, duration: toastDuration);
      }
    }
    notifyListeners();
  }

  Future<void> linkUser(int id, int isFamily) async {
    http.Response _res = await http.post(Uri.parse(linkUserUrl),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${token}"
        },
        body: jsonEncode(
            {'user_id': id, 'update_id': sheet!.id, 'isFamily': isFamily}));

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

  Future<void> checkSearch(int id, String type) async {
    print('type');
    http.Response _res = await http.post(Uri.parse(checkSearchUrl),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${token}"
        },
        body: jsonEncode({
          'id': [...sheet!.rx!.map((e) => e!.id)],
          'user_id': id,
          'type': int.parse(type)
        }));

    if (_res.statusCode == 200) {
      var json = await jsonDecode(_res.body);
      if (json['status']) {
        if (json['code'] == 200) {
        } else {
          Toast.show(json['message'],
              backgroundColor: Colors.red, duration: toastDuration);
          print(json['data']);
          throw {'data': json['data'], 'message': json['message']};
        }
      } else {
        Toast.show(json['message'],
            webTexColor: Colors.red, duration: toastDuration);
      }
    }
  }

  void removeImage(int index) {
    sheetToSend!.removeImage(index);
    notifyListeners();
  }
}
