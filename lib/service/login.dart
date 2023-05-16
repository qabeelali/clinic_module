import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class SharedService {
  SharedService() {
    initialize();
  }
  late SharedPreferences shared;
  Future<void> initialize() async {
    shared = await SharedPreferences.getInstance();
  }

  User? getUser() {
    return User(
        token: shared.get('token') as String, type: shared.get('type') as int);
  }

  void saveUser(User user) {
    shared.setString('token', user.token);
    shared.setInt('type', user.type);
  }
}
