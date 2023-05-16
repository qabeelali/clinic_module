import 'package:flutter_nps/model/sheet.dart';

class PharmacyItem {
  PharmacyItem({
    required this.update_id,
    required this.type_id,
    required this.name,
    required this.date,
    required this.is_seen,
  });
  final int update_id;
  final int type_id;
  final String name;
  final String date;
  final bool is_seen;

  factory PharmacyItem.fromJson(Map<String, dynamic> json) {
    return PharmacyItem(
        update_id: json['update_id'],
        type_id: json['type_id'],
        name: json['user_info']['name'],
        date: json['user_info']['date'],
        is_seen: json['is_seen']);
  }
}

class Recieved {
  Recieved(
      {required this.doctor,
      this.readiology,
      required this.user_info,
      this.rx,
      required this.id,
      this.lab,
      this.ultrasound,
      this.other,
      this.is_seen,
      this.date});
  final Doctor doctor;
  final UserInfo user_info;
  final List<Rx>? rx;
  final String? date;
  final int id;
  final List<Radiology>? readiology;
  final List<Lab>? lab;
  final List<Ultrasound>? ultrasound;
  final List<Other>? other;
  final bool? is_seen;
  factory Recieved.fromJson(Map<String, dynamic> json) {
    return Recieved(
        doctor: Doctor.fromJson(json['doctor_info']),
        id: json['id'],
        user_info: UserInfo.fromJson(json['user_info']),
        rx: json['rx'] != null
            ? [...json['rx'].map((e) => Rx.fromJson(e))]
            : [],
        date: json['date'],
        readiology: json['radiology'] != null
            ? [...json['radiology'].map((e) => Radiology.fromJson(e))]
            : [],
        ultrasound: json['ultrasound'] != null
            ? [...json['ultrasound'].map((e) => Ultrasound.fromJson(e))]
            : [],
        lab: json['lab'] != null
            ? [...json['lab'].map((e) => Lab.fromJson(e))]
            : [],
        other: json['other'] != null
            ? [...json['other'].map((e) => Other.fromJson(e))]
            : [],
        is_seen: json['is_seen']);
  }
}
