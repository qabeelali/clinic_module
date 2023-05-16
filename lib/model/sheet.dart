import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class Sheet {
  Sheet(
      {required this.patient_name,
      required this.gender,
      required this.user_id,
      required this.date,
      this.weight,
      required this.age,
      required this.update_id,
      required this.user_image,
      required this.doctor,
      required this.id});
  int id;
  String? patient_name;
  String? gender;
  int? user_id;
  String? date;
  String? weight;
  String? age;
  int update_id;
  String? user_image;
  Doctor? doctor;

  factory Sheet.fromJson(Map<String, dynamic> json) {
    print(json['user_image']);
    return Sheet(
        patient_name: json['patient_name'],
        gender: json['gender'],
        user_id: json['user_id'],
        date: json['date'],
        weight: json['weight'],
        age: json['age'],
        update_id: json['update_id'],
        user_image: json['user_image'],
        doctor: Doctor.fromJson(
          json['doctor'],
        ),
        id: json['id']);
  }
}

class Doctor {
  Doctor({
    required this.id,
    required this.image,
    required this.full_name,
    required this.name,
    this.bio,
    this.country_name,
    this.city_name,
    this.gender_text,
    this.account_type_name,
    this.healthcare_specialty_name,
    this.qr_code_image,
    this.is_block,
    this.age,
  });

  int id;
  String image;
  String full_name;
  String name;
  String? bio;
  String? country_name;
  String? city_name;
  String? gender_text;
  String? account_type_name;
  String? healthcare_specialty_name;
  String? qr_code_image;
  bool? is_block;
  int? age;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      image: json['image'],
      full_name: json['full_name'],
      name: json['name'],
      bio: json['bio'],
      country_name: json['country_name'],
      city_name: json['city_name'],
      gender_text: json['gender_text'],
      account_type_name: json['account_type_name'],
      healthcare_specialty_name: json['healthcare_specialty_name'],
      qr_code_image: json['qr_code_image'],
      is_block: json['is_block'],
      age: json['age'],
    );
  }
}

class Update {
  final List<dynamic> update_list;
  final UserInfo patientInfo;
  final int id;
  final String date;
  final int sheetId;
  final Dx dx;
  final List<Rx?> rx;
  final List<Radiology?> radiology;
  final List<Ultrasound?> ultrasound;
  final List<Lab?> lab;
  final Doctor doctor_info;
  final List<Other?> other;
  final String? linked;

  Update(
      {required this.patientInfo,
      required this.sheetId,
      required this.doctor_info,
      required this.update_list,
      required this.id,
      required this.date,
      required this.dx,
      required this.rx,
      required this.radiology,
      required this.ultrasound,
      required this.lab,
      required this.other,
      this.linked});

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
        doctor_info: Doctor.fromJson(json['doctor_info']),
        patientInfo: UserInfo.fromJson(json['user_info']),
        update_list: json['update_list'],
        id: json['id'],
        date: json['date'],
        dx: Dx.fromJson(json['dx']),
        rx: [...json['rx'].map((e) => Rx.fromJson(e))],
        radiology: [...json['radiology'].map((e) => Radiology.fromJson(e))],
        ultrasound: [...json['ultrasound'].map((e) => Ultrasound.fromJson(e))],
        lab: [...json['lab'].map((e) => Lab.fromJson(e))],
        other: [...json['other'].map((e) => Other.fromJson(e))],
        sheetId: json['sheet_id'],
        linked: json['linked']);
  }
}

class UserInfo {
  UserInfo({
    required this.patient_name,
    this.weight,
    required this.age,
    required this.gender,
  });

  final String patient_name;
  final String? weight;
  final String age;
  final String gender;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      patient_name: json['patient_name'],
      weight: json['weight'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}

class Dx {
  Dx({required this.content, required this.file_url});
  String content;
  List file_url;

  factory Dx.fromJson(Map<String, dynamic> json) {
    return Dx(
      content: json['content'],
      file_url: json['file_url'],
    );
  }
  Map<String, dynamic> toJson() => {
        'content': content,
        'files': file_url,
      };
}

class Rx {
  Rx(
      {required this.id,
      required this.count,
      required this.isAccepted,
      this.user_id,
      required this.drug_name,
      this.orderId,
      this.description});
  final int id;
  final String count;
  final int isAccepted;
  final int? user_id;
  final String drug_name;
  final String? description;
  final int? orderId;

  factory Rx.fromJson(Map<String, dynamic> json) {
    return Rx(
      id: json['drug_list_id'],
      count: json['count'],
      orderId: json['id'],
      isAccepted: json['isAccepted'],
      drug_name: json['drug_name'],
      description: json['received_note'],
    );
  }
  Map<String, dynamic> toJson() => {
        'drug_id': id,
        'count': count,
        // 'isAccepted': isAccepted,
        // 'user_id': user_id,
        // 'drug_name': drug_name,
        // 'description': description,
      };
}

class Radiology {
  Radiology(
      {required this.id,
      required this.description_note,
      required this.received_note,
      required this.user_id,
      required this.isAccepted,
      required this.radiology_name,
      required this.file_url,
      this.orderId,
      this.radiology_info});
  final int id;
  String description_note;
  final String? received_note;
  final int? user_id;
  final int isAccepted;
  final String radiology_name;
  final List file_url;
  final int? orderId;
  final RadiologyInfo? radiology_info;

  factory Radiology.fromJson(Map<String, dynamic> json) {
    return Radiology(
        id: json['id'],
        description_note: json['description_note'],
        orderId: json['radiology_id'],
        received_note: json['received_note'],
        user_id: json['user_id'],
        isAccepted: json['isAccepted'],
        radiology_name: json['radiology_name'],
        file_url: json['file_url'] ?? [],
        radiology_info: json['radiology_info'] != null
            ? RadiologyInfo.fromJson(json['radiology_info'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'radiology_id': id,
      'description_note': description_note,
    };
  }
}

class Ultrasound {
  Ultrasound({
    required this.description_note,
    required this.received_note,
    required this.id,
    required this.name,
    required this.isAccepted,
    required this.file_url,
  });
  final int id;
  final String name;
  final String description_note;
  final String? received_note;
  final int isAccepted;
  final List file_url;

  factory Ultrasound.fromJson(Map<String, dynamic> json) {
    return Ultrasound(
      description_note: json['description_note'],
      received_note: json['received_note'],
      id: json['id'],
      name: json['name'],
      isAccepted: json['isAccepted'],
      file_url: json['file_url'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description_note': description_note,
      'name': name,
      // 'received_note': received_note,
    };
  }
}

class Lab {
  final int id;

  final int isAccepted;
  final String labtest_name;
  final String? labtest_id;
  final List? content;
  Lab({
    required this.id,
    this.content,
    required this.isAccepted,
    required this.labtest_name,
    this.labtest_id,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id'],
      isAccepted: json['isAccepted'],
      content: json['content'],
      labtest_name: json['labtest_name'],
      labtest_id: json['labtest_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labtest_id': labtest_id,
    };
  }
}

class MinLab {}

class Other {
  Other(
      {required this.id,
      required this.name,
      required this.description_note,
      this.received_note,
      required this.isAccepted,
      this.type,
      this.file_url});

  final int id;
  final String name;
  final String description_note;
  final String? received_note;
  final int isAccepted;
  final List? file_url;
  final String? type;

  factory Other.fromJson(Map<String, dynamic> json) {
    return Other(
      id: json['id'],
      name: json['name'],
      description_note: json['description_note'],
      isAccepted: json['isAccepted'],
      file_url: json['file_url'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'description_note': description_note,
      'name': name,
      // 'received_note': received_note,
    };
  }
}

class RadiologyInfo {
  RadiologyInfo(
      {required this.id,
      required this.name,
      required this.full_name,
      required this.image});

  final int id;
  final String name;
  final String full_name;
  final String image;

  factory RadiologyInfo.fromJson(Map<String, dynamic> json) {
    return RadiologyInfo(
      id: json['id'],
      name: json['name'],
      full_name: json['full_name'],
      image: json['image'],
    );
  }
}

class SheetToSend {
  SheetToSend(
      {required this.patientName,
      required this.gender,
      required this.weight,
      required this.dx,
      required this.age,
      this.ultrasound,
      this.radiology,
      this.other,
      this.lab,
      this.sheetId,
      this.rx});

  String patientName;
  String age;
  int? sheetId;
  int gender;
  String weight;
  Dx dx;
  List<Rx>? rx;
  List<Radiology>? radiology;
  List<Lab>? lab;
  List<Ultrasound>? ultrasound;
  List<Other>? other;

  /* ######### Start RX ########## */
  void addDrug(Rx drug) {
    rx!.add(drug);
  }

  void setDxContent(String content) {
    dx.content = content;
  }

  void clearDrugs() {
    rx!.clear();
  }

  void removeRx(int id) {
    rx!.removeWhere((element) => element!.id == id);
  }
  /* ######### End RX ########## */

  /* ######### Start Radiology ########## */
  void addRadiology(Radiology radio) {
    radiology!.add(radio);
    radiology!.forEach((element) {
      print(element.toJson());
    });
  }

  void clearRadiology() {
    radiology!.clear();
  }

  void removeRadiology(int id) {
    radiology!.removeWhere((element) => element!.id == id);
  }

  void createRadiology() {
    radiology = [];
  }

  void removeRadiologyContainer() {
    radiology = null;
  }

  /* ######### End Radiology ########## */

  void editDxFiles(String method, {File? file}) {
    if (method == 'clear') {
      dx.file_url.clear();
    } else {
      if (file != null) {
        dx.file_url.add(file);
      } else {
        throw 'no file added';
      }
    }
  }

  void createRx() {
    rx = [];
  }

  void removeRxContainer() {
    rx = null;
  }

  void addImage(File file) {
    dx.file_url.add(base64Encode(file.readAsBytesSync()));
  }

  void removeImage(int index) {
    dx.file_url.removeAt(index);
  }

  void createRadiologyContainer() {
    radiology = [];
  }

  void createLabContainer() {
    lab = [];
  }

  void removeLabContainer() {
    lab = null;
  }

  void addLab(Lab labItem) {
    lab!.add(labItem);
  }

  void removeLab(int id) {
    lab!.removeWhere((element) => element!.id == id);
  }

  createUltrasoundContainer() {
    ultrasound = [];
  }

  removeUltrasoundContainer() {
    ultrasound = null;
  }

  addUltrasound(Ultrasound _ultrasound) {
    ultrasound!.add(_ultrasound);
  }

  removeUltrasound(int id) {
    ultrasound!.removeWhere((element) => element!.id == id);
  }

  createOtherContainer() {
    other = [];
  }

  removeOtherContainer() {
    other = null;
  }

  addOther(Other _other) {
    other!.add(_other);
  }

  Map<String, dynamic> toJson() => {
        'patient_name': patientName,
        'gender': gender,
        'weight': weight,
        'lab': lab != null ? lab!.map((e) => e.toJson()).toList() : [],
        'dx': dx.toJson(),
        'rx': rx != null ? rx!.map((r) => r.toJson()).toList() : null,
        'radiology': radiology != null
            ? radiology!.map((r) => r!.toJson()).toList()
            : null,
        'age': age,
        'sheet_id': sheetId.toString(),
        'ultrasound': ultrasound != null
            ? ultrasound!.map((r) => r!.toJson()).toList()
            : null,
        'othertest':
            other != null ? other!.map((r) => r!.toJson()).toList() : null,
      };
}

class Drug {
  Drug({required this.id, required this.name});
  final String name;
  final int id;

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(id: json['id'], name: json['name']);
  }
}
