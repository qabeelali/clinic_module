import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/login.dart';

class userController extends ChangeNotifier {
  SharedService _service = SharedService();
  User? user;
  bool isLogin = false;

  Future<void> getUserFromShared() async {
    await _service.initialize();
    user = _service.getUser();
    isLogin = user != null;
    notifyListeners();
  }

  Future<void> login(String token, int type) async {
    _service.initialize();

    user = User(token: token, type: type);
    isLogin = user != null;
    _service.saveUser(user!);
    notifyListeners();
  }
}
