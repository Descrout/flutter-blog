import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/widgets/article_widget.dart';
import 'package:flutter_blog/widgets/guest_drawer.dart';
import 'package:flutter_blog/widgets/user_drawer.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (_, user, __) => (user.status == AuthStatus.Authenticated
              ? UserDrawer()
              : GuestDrawer()),
        ),
      ),
      body: Consumer<ArticleProvider>(
        builder: (_, articles, __) => RefreshIndicator(
            child: _buildArticles(articles), onRefresh: articles.refresh),
      ),
    );
  }

  Widget _buildArticles(ArticleProvider articles) {
    return ListView.separated(
        itemBuilder: (ctx, i) {
          if (i < articles.length) {
            return ArticleWidget(article: articles.at(i));
          }
          articles.extend();
          return Center(child: CircularProgressIndicator());
        },
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: articles.listLength);
  }
}
