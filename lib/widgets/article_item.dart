import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/edit_item.dart';
import 'package:provider/provider.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  ArticleItem(this.article);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, Routes.Article, arguments: article.id);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      leading: leading(),
      title: Text(
        article.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle(),
      trailing: date(context),
    );
  }

  Widget commentChip() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        child: Row(
          children: [
            Icon(Icons.comment_rounded,
                color:
                    article.commentStatus ? Colors.blueAccent : Colors.black45),
            Text('${article.commentCount} ')
          ],
        ),
      ),
    );
  }

  Widget favChip() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        child: Row(
          children: [
            (article.favoriteStatus
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border, color: Colors.black45)),
            Text('${article.favoriteCount} '),
          ],
        ),
      ),
    );
  }

  Widget date(BuildContext context) {
    return Column(
      children: [
        Text(
          '·${article.createdAt.passedSinceStr()}', //${article.createdAt.toString()}\n
          style: TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
        Globals.shared.canManageArticle(article)
            ? EditItem<Article>(
                what: 'Article',
                endpoint: '/api/articles/${article.id}',
                onUpdate: (articleResponse) async {
                  Provider.of<ValidationProvider>(context, listen: false)
                      .initArticle(articleResponse.title, articleResponse.body);
                  Navigator.of(context).pushNamed(
                    Routes.Update,
                    arguments: articleResponse,
                  );
                },
                onRemoveSuccess:
                    Provider.of<ListProvider<Article>>(context).refresh,
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget leading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Colors
            .indigo, // Colors.primaries[Random().nextInt(Colors.primaries.length)]
        width: 50,
        height: 64,
        child: Center(
          child: Text(
            '${article.title.characters.first.toUpperCase()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitle() {
    return Row(
      children: [user(), favChip(), commentChip()],
    );
  }

  Widget user() {
    return SizedBox(
      width: 80,
      child: Text(
        '@${article.user.name}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
