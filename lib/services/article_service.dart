import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/services/service.dart';

class ArticleService extends Service {
  ArticleService() : super("/api/articles");

  Future<APIResponse<List<Article>>> getArticles() async {
    var res = await super.getItems();
    if (res.error) return res;

    return APIResponse(
        data: res.data.map((article) => Article.fromJson(article)).toList());
  }
}
