import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/utils/query_params.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ArticleService {

  Future<Item<List<Article>>> getArticles(QueryParams params) async {
    final uri = Uri.http(Globals.SERVER, "/api/articles", params.getAll());
    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Globals.shared.token}',
    });

    final parsed = convert.jsonDecode(res.body);
    if (res.statusCode == 200) {
      final items = parsed as List;
      return Item(
          data: items.map((article) => Article.fromJson(article)).toList());
    }
    return Item(error: parsed['status'] ?? 'Cannot get articles.');
  }
}
