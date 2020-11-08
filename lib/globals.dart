import 'package:flutter_blog/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class Item<T> {
  final T data;
  final bool success;
  final String error;
  Item({this.data, this.error}) : success = data != null;
}

class Globals {
  static const SERVER = "206.189.111.249:6444";
  static const TITLE = "Flutter Blog App";
  static const ARTICLES_IN_PAGE = 10;
  static const USERS_IN_PAGE = 10;

  Globals._internal();
  static final Globals shared = Globals._internal();

  User user;
  String token;

  readFromFile() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    token = storage.getString('token');
    final userStr = storage.getString('user');
    if (userStr != null) {
      user = User.fromJson(convert.jsonDecode(userStr));
    } else {
      user = null;
    }
  }

  saveToFile() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString('token', token);
    storage.setString('user', convert.jsonEncode(user.toJson()));
  }

  clear() async {
    user = null;
    token = null;
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
