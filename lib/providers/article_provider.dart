import 'package:flutter/widgets.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/services/article_service.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles;
  ArticleService articleService;
  int _lastCount;

  ArticleProvider() {
    this._articles = List<Article>();
    this.articleService = ArticleService();
    this.add();
  }

  int get length => this._articles.length;
  int get listLength => this._articles.length + (this.hasMore ? 1 : 0);
  bool get hasMore => _lastCount == Constants.ARTICLE_IN_PAGE;
  Article at(int i) => this._articles[i];

  Future<void> refresh() {
    this.articleService = ArticleService();
    this._articles.clear();
    return this.add();
  }

  void extend() {
    this.articleService.params.page += 1;
    this.add();
  }

  Future<void> add() async {
    var articles = await this.articleService.getArticles();
    if (!articles.error) {
      this._lastCount = articles.data.length;
      this._articles.addAll(articles.data);
      notifyListeners();
    }
  }
}
