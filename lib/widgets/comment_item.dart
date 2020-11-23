import 'package:flutter/material.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/providers/comments_provider.dart';
import 'package:flutter_blog/providers/user_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/edit_item.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool inUserPage;
  CommentItem(this.comment) : inUserPage = comment.articleID != null;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (!inUserPage)
          Navigator.pushNamed(context, Routes.User, arguments: comment.user.id);
        else
          Navigator.pushNamed(context, Routes.Article,
              arguments: comment.articleID);
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
      trailing: Globals.shared.canManageComment(comment)
          ? EditItem<Comment>(
              what: 'Comment',
              endpoint: '/api/comments/id/${comment.id}',
              onUpdate: (commentResponse) async {
                final error = await _showCommentEditor(context);
                if (error != null) {
                  if (inUserPage)
                    Provider.of<UserProvider>(context, listen: false)
                        .refreshComments();
                  else
                    Provider.of<CommentsProvider>(context, listen: false)
                        .refresh();
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(error == 'Success'
                          ? 'Comment updated successfuly.'
                          : error)));
                }
              },
              onRemoveSuccess: () {
                if (inUserPage)
                  Provider.of<UserProvider>(context, listen: false)
                      .refreshComments();
                else
                  Provider.of<CommentsProvider>(context, listen: false)
                      .refresh();
              },
            )
          : SizedBox.shrink(),
    );
  }

  Future<String> _showCommentEditor(context) {
    final bodyController = TextEditingController(text: comment.body);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text("Update the comment : "),
        content: TextField(
          controller: bodyController,
          decoration:
              Styles.input.copyWith(hintText: 'Body', labelText: 'Body'),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
              onPressed: () async {
                final body = bodyController.text;
                if (body == null || body == "") return;
                if (body == comment.body) {
                  Navigator.of(ctx).pop();
                } else {
                  final resp = await Blog.editComment(comment.id, body);
                  // null means success
                  Navigator.of(ctx).pop(resp ?? 'Success');
                }
                bodyController.dispose();
              },
              child: Text("Ok")),
        ],
      ),
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
