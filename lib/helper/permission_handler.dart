import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class myPermissionHandler{
 static Future<bool> checkPermission() async {
    final status = await Permission.photos.status;
    print(status == PermissionStatus.granted);
    return status == PermissionStatus.granted;

}

static Future<void> requestPermission() async {
  if (Platform.isIOS) {
    final status = await Permission.photos.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permission not granted');
    }
  } else {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permission not granted');
    }
  }
}

}