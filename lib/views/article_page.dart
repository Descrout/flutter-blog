import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:provider/provider.dart';

const splashUrls = [
  "https://images.unsplash.com/photo-1430797877645-98aa0693fb34?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80",
  "https://images.unsplash.com/photo-1418985227304-f32df7d84e39?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  "https://images.unsplash.com/photo-1542318099375-c20b8c991bbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  "https://images.unsplash.com/photo-1541338906008-f2d4ad1b2231?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
  "https://images.unsplash.com/photo-1552863045-991883e6f59b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=889&q=80",
];

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    final article = context.select((ArticleProvider ap) => ap.article);
    if (article == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (!article.success) {
      //maybe add information modal here to inform user about article error
      Navigator.of(context).pop();
      return SizedBox.shrink();
    }

    final _commentColor =
        article.data.commentStatus ? Colors.blue : Colors.grey[700];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: articleProvider.fetch,
        child: CustomScrollView(
          controller: articleProvider.controller,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              title: Text(article.data.title),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  splashUrls[Random().nextInt(splashUrls.length)],
                  fit: BoxFit.cover,
                ),
              ),
              expandedHeight: 250,
            ),
            SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                      [ArticleReadingPage(article.data)]),
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            if (i == 0)
              articleProvider.toggleFavorite();
            else if (i == 1)
              articleProvider.controller.animateTo(
                0,
                duration: Duration(milliseconds: 1500),
                curve: Curves.fastOutSlowIn,
              );
            else
              print("comments");
          },
          items: [
            BottomNavigationBarItem(
              icon: Selector<ArticleProvider, FavResponse>(
                builder: (_, favResponse, __) => Icon(Icons.favorite,
                    color:
                        favResponse.favStatus ? Colors.red : Colors.grey[700]),
                selector: (_, ap) => ap.favResponse,
              ),
              title: Selector<ArticleProvider, FavResponse>(
                builder: (_, favResponse, __) => Text(
                  '${favResponse.favCount}',
                  style: TextStyle(
                      color: favResponse.favStatus
                          ? Colors.red
                          : Colors.grey[700]),
                ),
                selector: (_, ap) => ap.favResponse,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward), title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: _commentColor),
                title: Text('${article.data.commentCount}',
                    style: TextStyle(color: _commentColor))),
          ]),
    );
  }
}

class ArticleReadingPage extends StatelessWidget {
  final Article article;
  ArticleReadingPage(this.article);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(article.title, style: Theme.of(context).textTheme.headline5),
          Divider(color: Colors.black, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '@${article.user.name}',
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                article.createdAt.toString(),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          SizedBox(height: 40),
          Text(
            article.body,
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.5,
              fontSize: 14,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
