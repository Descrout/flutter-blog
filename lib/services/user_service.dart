import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserService {
  Future<Item<User>> login(String email, String password) async {
    final uri = Uri.http(Globals.SERVER, '/login', {'remember': '1'});
    final res = await http.post(uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({
          'email': email,
          'password': password,
        }));

    print('$email -- $password');

    final parsed = convert.jsonDecode(res.body);
    if (res.statusCode == 200) {
      Globals.shared.token = parsed['token'];
      return Item(data: User.fromJson(parsed));
    }
    return Item(error: parsed['error'] ?? 'Cannot login.');
  }
}
