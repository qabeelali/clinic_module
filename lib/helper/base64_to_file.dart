import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../controller/ptient_controller.dart';

class SaiHelper {
  static Future<File> convertBase64ToFile(String base64String) async {
    final bytes = base64.decode(
        base64String.replaceAll(RegExp(r'^data:image/\w+;base64,'), ''));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_file');
    await file.writeAsBytes(bytes);
    return file;
  }

  static void showNativeDialog(BuildContext context, Widget title,
      {String? message, actions, index}) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: message != null ? Text(message) : Container(),
            actions: <Widget>[
              ...actions.map(
                (e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Provider.of<PatientController>(context, listen: false)
                        .removeImage(index);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: message != null ? Text(message) : Container(),
            actions: <Widget>[
              ...actions.map(
                (e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Provider.of<PatientController>(context, listen: false)
                        .removeImage(index);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        },
      );
    }
  }
}
