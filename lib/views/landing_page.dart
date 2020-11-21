import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
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
          builder: (article) => ArticleItem(article),
          tab: Tab(text: "Articles", icon: Icon(Icons.article)),
          filter: ListFilter<Article>(),
          fButton: Builder(builder: (ctx) {
            return FloatingActionButton(
              child: Icon(Icons.create),
              onPressed: () {
                if (Globals.shared.token == null) {
                  showDialog<bool>(
                    context: ctx,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      title: Text("Cannot write an article !"),
                      content: Text("You must login to write an article."),
                      actions: [
                        TextButton(
                            onPressed: Navigator.of(ctx).pop,
                            child: Text("OK")),
                      ],
                    ),
                  );
                } else
                  Navigator.of(ctx).pushNamed(Routes.Create);
              },
            );
          }),
        );
}
