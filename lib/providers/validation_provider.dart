import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';

class ValidationProvider with ChangeNotifier {
  //Regex
  static final nameRegex =
      RegExp(r"^[a-zA-Z]+((([',. -][a-zA-Z ])?[a-zA-Z]){2,20})$");
  static final emailRegex = RegExp(r"(.+)@(.+){2,}\.(.+){2,}");
  static final passwordRegex = RegExp(r"^(\S{6,20})$");

  //Validation Items
  Item<String> _name = Item<String>();
  Item<String> get name => _name;

  Item<String> _mail = Item<String>();
  Item<String> get mail => _mail;

  Item<String> _password = Item<String>();
  Item<String> get password => _password;

  Item<String> _rePassword = Item<String>();
  Item<String> get rePassword => _rePassword;

  Item<String> _title = Item<String>();
  Item<String> get title => _title;

  Item<String> _body = Item<String>();
  Item<String> get body => _body;

  //Validation Shortcuts
  void Function() isLoginValid(VoidCallback cb) =>
      _mail.success && _password.success ? cb : null;

  void Function() isRegisterValid(VoidCallback cb) =>
      _name.success && _mail.success && _password.success && _rePassword.success
          ? cb
          : null;

  void Function() isArticleValid(VoidCallback cb) =>
      _title.success && _body.success ? cb : null;

  // Validation cleanup
  void clearRegister() {
    _name = Item();
    _password = Item();
    _rePassword = Item();
    notifyListeners();
  }

  void clearLogin() {
    _mail = Item();
    _password = Item();
    notifyListeners();
  }

  void clearArticleCreation() {
    _title = Item();
    _body = Item();
    notifyListeners();
  }

  //Validation Checks
  void checkName(String value) {
    if (nameRegex.hasMatch(value)) {
      _name = Item(data: value);
    } else {
      _name = Item(error: "Invalid name.");
    }
    notifyListeners();
  }

  void checkMail(String value) {
    if (emailRegex.hasMatch(value)) {
      _mail = Item(data: value);
    } else {
      _mail = Item(error: "Invalid e-mail.");
    }
    notifyListeners();
  }

  void checkPassword(String value) {
    if (passwordRegex.hasMatch(value)) {
      _password = Item(data: value);
    } else {
      _password = Item(error: "Invalid password.");
    }
    notifyListeners();
  }

  void checkRePassword(String value) {
    if (value == _password.data) {
      _rePassword = Item(data: value);
    } else {
      _rePassword = Item(error: "Passwords don't match.");
    }
    notifyListeners();
  }

  void checkTitle(String title) {
    if (title.trimLeft().trimRight().length > 10) {
      _title = Item(data: title);
    } else {
      _title = Item(error: "Title must be atleast 10 character.");
    }
    notifyListeners();
  }

  void checkBody(String body) {
    if (body.trimLeft().trimRight().length > 20) {
      _body = Item(data: body);
    } else {
      _body = Item(error: "Body must be atleast 20 character.");
    }
    notifyListeners();
  }
}
