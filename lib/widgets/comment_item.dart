import 'package:flutter/material.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/views/routes.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool link;
  const CommentItem(this.comment, this.link);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (link)
          Navigator.pushNamed(context, Routes.User, arguments: comment.user.id);
      },
      leading: leading(comment.user.getImageURL),
      title: Text.rich(
        TextSpan(
          text: comment.user.name,
          children: [
            TextSpan(
              text: ' · ${comment.createdAt.passedSinceStr()} ago',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            )
          ],
        ),
      ),
      subtitle: Text('\n${comment.body}'),
    );
  }

  Widget leading(String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
