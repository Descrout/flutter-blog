import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: Consumer<ArticleProvider>(
          builder: (ctx, articles, child) => RefreshIndicator(
              child: _buildArticles(articles), onRefresh: articles.refresh)),
    );
  }

  Widget _buildArticles(ArticleProvider articles) {
    return ListView.separated(
        itemBuilder: (ctx, i) {
          if (i < articles.length) {
            return _buildRow(articles.at(i));
          }
          articles.extend();
          return Center(child: CircularProgressIndicator());
        },
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: articles.listLength);
  }

  Widget _buildRow(Article article) {
    return ListTile(
      title: Text(article.title),
      leading: Text(article.id.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${article.commentCount} '),
              Icon(
                Icons.comment,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 50,
              ),
              Text('${article.favoriteCount} '),
              (article.favoriteStatus
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border, color: Colors.red)),
            ],
          ),
          Text(
              '${article.createdAt.toString()} - ${article.createdAt.passedSinceStr()}'),
        ],
      ),
    );
  }
}
