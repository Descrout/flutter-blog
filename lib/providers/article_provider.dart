import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/services/article_service.dart';
import 'package:flutter_blog/utils/query_params.dart';

class ArticleProvider with ChangeNotifier {
  final ArticleService _service = ArticleService();

  List<Article> _articles;
  int _lastCount;
  QueryParams _params = QueryParams();

  ArticleProvider()
      : _params = QueryParams(),
        _articles = List<Article>() {
    this.add();
  }

  int get length => _articles.length;
  int get listLength => _articles.length + (this.hasMore ? 1 : 0);
  bool get hasMore => _lastCount == Globals.ARTICLE_IN_PAGE;
  Article at(int i) => _articles[i];

  Future<void> refresh() {
    _params = QueryParams();
    _articles.clear();
    return this.add();
  }

  void extend() {
    _params.page += 1;
    this.add();
  }

  Future<void> add() async {
    final articles = await _service.getArticles(_params);
    if (articles.success) {
      this._lastCount = articles.data.length;
      _articles.addAll(articles.data);
      notifyListeners();
    }
  }
}
