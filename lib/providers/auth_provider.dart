import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/list_provider.dart';

enum AuthStatus { Authenticating, Authenticated, Unauthenticated }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.Unauthenticated;
  AuthStatus get status => _status;

  String _error;
  String get error => _error;

  AuthProvider(ListProvider<Article> articles, ListProvider<User> users) {
    init(articles, users);
  }

  init(ListProvider<Article> articles, ListProvider<User> users) async {
    await Globals.shared.readFromFile();
    articles.fetch();
    users.fetch();
    if (Globals.shared.token != null) {
      _status = AuthStatus.Authenticated;
    } else {
      _status = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  Future<Item<User>> changeEmail(String email, String password) async {
    final user = await Blog.changeEmail(email, password);
    if (user.success) {
      Globals.shared.user = user.data;
      Globals.shared.saveToFile();
      notifyListeners();
    }

    return user;
  }

  Future<Item<User>> changeName(String name) async {
    final user = await Blog.changeName(name);
    if (user.success) {
      Globals.shared.user = user.data;
      Globals.shared.saveToFile();
      notifyListeners();
    }

    return user;
  }

  Future<Item<User>> changePicture(String path) async {
    final user = await Blog.changeImage(path);
    if (user.success) {
      Globals.shared.user = user.data;
      Globals.shared.saveToFile();
      notifyListeners();
    }

    return user;
  }

  login(String email, String password) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    final user = await Blog.login(email, password);
    if (user.success) {
      _status = AuthStatus.Authenticated;
      Globals.shared.user = user.data;
      await Globals.shared.saveToFile();
    } else {
      _status = AuthStatus.Unauthenticated;
      await Globals.shared.clear();
      _error = user.error;
    }
    notifyListeners();
  }

  logout() async {
    _status = AuthStatus.Unauthenticated;
    await Globals.shared.clear();
    notifyListeners();
  }
}
