import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/utils/query_params.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'globals.dart';
import 'models/article.dart';
import 'models/comment.dart';
import 'models/user.dart';

abstract class Blog {
  static T fromJson<T>(Map<String, dynamic> json) {
    if (T == Article) {
      return Article.fromJson(json) as T;
    } else if (T == User) {
      return User.fromJson(json) as T;
    } else if (T == Comment) {
      return Comment.fromJson(json) as T;
    }
    throw "Invalid model type $T";
  }

  static Future<Item<User>> changePassword(
      String newPass, String curPass) async {
    try {
      final id = Globals.shared.user.id;
      final uri = Uri.http(Globals.SERVER, '/api/users/$id/password');
      final res = await http.put(uri,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Globals.shared.token}',
          },
          body: convert
              .jsonEncode({'oldPassword': curPass, 'password': newPass}));

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item<User>(data: User.fromJson(parsed));
      }
      throw Exception(
          parsed['error'] ?? 'Unknown error while changing password.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<User>> changeEmail(String email, String password) async {
    try {
      final id = Globals.shared.user.id;
      final uri = Uri.http(Globals.SERVER, '/api/users/$id/email');
      final res = await http.put(uri,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Globals.shared.token}',
          },
          body: convert.jsonEncode({'email': email, 'password': password}));

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item<User>(data: User.fromJson(parsed));
      }
      throw Exception(parsed['error'] ?? 'Unknown error while changing email.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<User>> changeName(String name) async {
    try {
      final id = Globals.shared.user.id;
      final uri =
          Uri.http(Globals.SERVER, '/api/users/$id/name', {'name': name});
      final res = await http.put(uri, headers: {
        'content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Globals.shared.token}',
      });

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item<User>(data: User.fromJson(parsed));
      }
      throw Exception(parsed['error'] ?? 'Unknown error while changing name');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<User>> changeImage(String path) async {
    try {
      final id = Globals.shared.user.id;
      final uri = Uri.http(Globals.SERVER, '/api/users/$id/image');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer ${Globals.shared.token}';
      request.files.add(await http.MultipartFile.fromPath('img', path));

      final req = await request.send();
      final res = await http.Response.fromStream(req);

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item<User>(data: User.fromJson(parsed));
      }
      throw Exception(parsed['error'] ?? 'Unknown error while updating image.');
    } catch (e) {
      return Item(error: e.toString());
    }
  }

  static Future<Item<int>> postArticle(String title, String body) async {
    try {
      final uri = Uri.http(Globals.SERVER, '/api/articles');
      final res = await http.post(uri,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Globals.shared.token}',
          },
          body: convert.jsonEncode({'title': title, 'body': body}));

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 201) {
        return Item<int>(data: parsed['id']);
      }
      throw Exception(
          parsed['error'] ?? 'Unknown error while posting article.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<Comment>> sendComment(
      BuildContext ctx, int articleID, String msg) async {
    try {
      final uri = Uri.http(Globals.SERVER, '/api/comments/$articleID');
      final res = await http.post(uri,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Globals.shared.token}',
          },
          body: convert.jsonEncode({'body': msg}));

      final parsed = convert.jsonDecode(res.body);
      if (res.statusCode == 201) {
        return Item(data: Comment.fromJson(parsed));
      } else if (res.statusCode == 401) {
        Provider.of<AuthProvider>(ctx, listen: false).logout();
        throw Exception('Your session is expired, please login again.');
      }
      throw Exception(parsed['error'] ?? 'Unknown error while commenting.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<FavResponse>> toggleFavorite(
      BuildContext ctx, int articleID) async {
    try {
      final uri = Uri.http(Globals.SERVER, '/api/articles/$articleID');
      final res = await http.post(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Globals.shared.token}',
      });

      final parsed = convert.jsonDecode(res.body);
      if (res.statusCode == 200) {
        return Item(data: FavResponse.fromJson(parsed));
      } else if (res.statusCode == 401) {
        Provider.of<AuthProvider>(ctx, listen: false).logout();
        throw Exception('Your session is expired, please login again.');
      }
      throw Exception(
          parsed['error'] ?? 'Unknown error while favorite toggle.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<T>> getSingle<T>(String endpoint) async {
    try {
      final uri = Uri.http(Globals.SERVER, endpoint);
      final res = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Globals.shared.token}',
      });

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item(data: fromJson<T>(parsed));
      }
      throw Exception(
          parsed['error'] ?? 'Unknown error while getting $endpoint');
    } catch (e) {
      return Item(error: e.toString());
    }
  }

  static Future<Item<List<T>>> getList<T>(
    String endpoint,
    QueryParams params,
  ) async {
    try {
      final uri = Uri.http(Globals.SERVER, endpoint, params.getAll());
      final res = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Globals.shared.token}',
      });

      final parsed = convert.jsonDecode(res.body);

      if (res.statusCode == 200) {
        return Item(data: parsed.map<T>((item) => fromJson<T>(item)).toList());
      }
      throw Exception(
          parsed['error'] ?? 'Unknown error while getting $endpoint');
    } catch (e) {
      return Item(error: e.toString());
    }
  }

  static Future<Item<User>> login(String email, String password) async {
    try {
      final uri = Uri.http(Globals.SERVER, '/login', {'remember': '1'});
      final res = await http.post(uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode({
            'email': email,
            'password': password,
          }));

      final parsed = convert.jsonDecode(res.body);
      if (res.statusCode == 200) {
        Globals.shared.token = parsed['token'];
        return Item(data: User.fromJson(parsed));
      }
      throw Exception(parsed['error'] ?? 'Unknown error while login.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<String> register(
      String name, String email, String password) async {
    try {
      final uri = Uri.http(Globals.SERVER, '/register');
      final res = await http.post(uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }));

      final parsed = convert.jsonDecode(res.body);
      if (res.statusCode == 201) {
        return null;
      }
      throw Exception(parsed['error'] ?? 'Unknown error while register.');
    } catch (e) {
      return e.toString().split(':')[1];
    }
  }
}
