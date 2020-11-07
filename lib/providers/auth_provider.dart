import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/services/user_service.dart';

enum AuthStatus { Authenticating, Authenticated, Unauthenticated }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.Unauthenticated;
  AuthStatus get status => _status;

  final UserService _service = UserService();

  String _error;
  String get error => _error;

  AuthProvider() {
    init();
  }

  init() async {
    await Globals.shared.readFromFile();
    if (Globals.shared.token != null) {
      _status = AuthStatus.Authenticated;
    } else {
      _status = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  login(String email, String password) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    final user = await _service.login(email, password);
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
