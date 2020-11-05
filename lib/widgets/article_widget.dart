import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blog/models/article.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final VoidCallback onPressed;

  ArticleWidget({@required this.article, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        leading: leading(),
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [favChip(), commentChip()],
        ),
        trailing: date(),
      ),
    );
  }

  Widget commentChip() {
    return Chip(
      avatar: Icon(
        Icons.comment,
        color: Colors.indigoAccent,
      ),
      label: Text('${article.commentCount} '),
    );
  }

  Widget favChip() {
    return Chip(
      avatar: (article.favoriteStatus
          ? Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : Icon(
              Icons.favorite_outline,
              color: Colors.red,
            )),
      label: Text('${article.favoriteCount} '),
    );
  }

  Widget date() {
    return Text(
      '${article.createdAt.toString()}\n${article.createdAt.passedSinceStr()}',
      style: TextStyle(fontSize: 11),
      textAlign: TextAlign.center,
    );
  }

  Widget leading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
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
}
