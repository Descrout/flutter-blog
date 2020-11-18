import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';

class ArticleProvider with ChangeNotifier {
  final int id;
  Item<Article> article;
  FavResponse favResponse;
  ScrollController controller = ScrollController();

  ArticleProvider(this.id) {
    fetch();
  }

  Future<String> toggleFavorite() async {
    final response = await Blog.toggleFavorite(article.data.id);
    if (response.success) {
      favResponse = response.data;
      notifyListeners();
      return null;
    } else {
      return response.error;
    }
  }

  Future<void> fetch() async {
    article = null;
    notifyListeners();
    final articleResponse = await Blog.getSingle<Article>('/api/articles/$id');
    if (!articleResponse.success) {
      print('Error while fetching article : ${articleResponse.error}');
    } else {
      favResponse = FavResponse(
          favStatus: articleResponse.data.favoriteStatus,
          favCount: articleResponse.data.favoriteCount);
    }
    article = articleResponse;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
