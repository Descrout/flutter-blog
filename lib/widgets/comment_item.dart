import 'package:flutter/material.dart';
import 'package:flutter_blog/models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
