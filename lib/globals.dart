import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/comment.dart';
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

  bool canManageArticle(Article article) {
    return article.user.id == user.id || user.role.code | 8 == user.role.code;
  }

  bool canManageComment(Comment comment) {
    return comment.user.id == user.id || user.role.code | 4 == user.role.code;
  }

  bool canManageUser() {
    return user.role.code | 64 == user.role.code;
  }

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
