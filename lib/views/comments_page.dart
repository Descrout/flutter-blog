import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/comments_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/widgets/comment_item.dart';
import 'package:flutter_blog/widgets/nothing_show.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<CommentsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Text("Comments"),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          TextFormField(
            controller: comments.controller,
            decoration: Styles.input.copyWith(
                hintText: 'Comment',
                labelText: 'Comment',
                errorText: comments.sendError),
            onFieldSubmitted: (msg) =>
                Provider.of<CommentsProvider>(context, listen: false)
                    .sendComment(context, msg),
          ),
          SizedBox(height: 5),
          Expanded(
            child: RefreshIndicator(
                child: _buildItems(comments),
                onRefresh: Provider.of<CommentsProvider>(context, listen: false)
                    .refresh),
          )
        ],
      ),
    );
  }

  Widget _buildItems(CommentsProvider comments) {
    return comments.items.isEmpty
        ? NothingToShow()
        : ListView.separated(
            itemBuilder: (ctx, i) {
              if (i < comments.items.length) {
                return CommentItem(comments.items[i]);
              }
              comments.fetch();
              return Center(child: CircularProgressIndicator());
            },
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: comments.items.listLength);
  }
}
