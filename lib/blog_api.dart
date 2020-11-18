import 'package:flutter_blog/utils/query_params.dart';
import 'package:http/http.dart' as http;
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

  static Future<Item<Comment>> sendComment(int articleID, String msg) async {
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
        throw Exception('You must login to send a comment.');
      }
      throw Exception(parsed['error'] ?? 'Unknown error while commenting.');
    } catch (e) {
      return Item(error: e.toString().split(':')[1]);
    }
  }

  static Future<Item<FavResponse>> toggleFavorite(int articleID) async {
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
        throw Exception('You must login to favorite an article.');
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
      return Item(error: e.toString());
    }
  }
}
