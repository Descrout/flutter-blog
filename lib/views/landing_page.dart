import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/views/list_page.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/list_filter.dart';
import 'package:flutter_blog/widgets/article_item.dart';

class LandingPage extends ListPage<Article> {
  LandingPage({Key key})
      : super(
          key: key,
          name: Routes.Landing,
          builder: (ctx, article) => ArticleItem(article),
          tab: Tab(text: "Articles", icon: Icon(Icons.article)),
          filter: ListFilter<Article>(),
        );
}
