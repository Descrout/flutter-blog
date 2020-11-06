import 'package:flutter/material.dart';
import 'package:flutter_blog/models/article.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final VoidCallback onPressed;

  ArticleWidget({@required this.article, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      leading: leading(),
      title: Text(
        article.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle(),
      trailing: date(),
    );
  }

  Widget commentChip() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        child: Row(
          children: [
            Icon(Icons.comment, color: Colors.black45),
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
            Icon(Icons.favorite, color: Colors.black45),
            Text('${article.favoriteCount} '),
          ],
        ),
      ),
    );
  }

  Widget date() {
    return Text(
      '·${article.createdAt.passedSinceStr()}', //${article.createdAt.toString()}\n
      style: TextStyle(fontSize: 11),
      textAlign: TextAlign.center,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [user(), info()],
    );
  }

  Widget user() {
    return SizedBox(
      width: 100,
      child: Text(
        '@${article.user.name}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget info() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [favChip(), commentChip()],
    );
  }
}
