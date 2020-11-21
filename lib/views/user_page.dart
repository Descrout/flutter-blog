import 'package:flutter/material.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/user_provider.dart';
import 'package:flutter_blog/utils/list_holder.dart';
import 'package:flutter_blog/widgets/article_item.dart';
import 'package:flutter_blog/widgets/comment_item.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProvider up) => up.user);

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (!user.success) {
      Navigator.of(context).pop();
      return SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: Text(user.data.name)),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _userField(context, user.data),
            _tabBar(),
            _lists(context),
          ],
        ),
      ),
    );
  }

  Widget _userField(BuildContext context, User user) {
    return ListTile(
      leading: Image.network(user.getImageURL),
      title: Text.rich(TextSpan(text: user.name, children: [
        TextSpan(
          text: ' · ${user.role.name}',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        )
      ])),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              Text('${user.karma}'),
            ],
          ),
          Text('${user.createdAt.passedSinceStr()} old'),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return const TabBar(
      labelColor: Colors.indigo,
      tabs: [
        Tab(text: "Posted"),
        Tab(text: "Favorited"),
        Tab(text: "Comments"),
      ],
    );
  }

  Widget _lists(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          _listPosted(),
          _listFavorited(),
          _listComments(),
        ],
      ),
    );
  }

  Widget _listPosted() {
    return Selector<UserProvider, ListHolder<Article>>(
      builder: (context, posted, _) {
        return RefreshIndicator(
          onRefresh:
              Provider.of<UserProvider>(context, listen: false).refreshPosted,
          child: ListView.separated(
            itemBuilder: (ctx, i) {
              if (i < posted.length) {
                return ArticleItem(posted[i]);
              }
              Provider.of<UserProvider>(context, listen: false).fetchPosted();
              return Center(child: CircularProgressIndicator());
            },
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: posted.listLength,
          ),
        );
      },
      selector: (_, up) => up.posted,
      shouldRebuild: (_, next) => next.isChanged(),
    );
  }

  Widget _listFavorited() {
    return Selector<UserProvider, ListHolder<Article>>(
      builder: (context, favorited, _) {
        return RefreshIndicator(
          onRefresh: Provider.of<UserProvider>(context, listen: false)
              .refreshFavorited,
          child: ListView.separated(
            itemBuilder: (ctx, i) {
              if (i < favorited.length) {
                return ArticleItem(favorited[i]);
              }
              Provider.of<UserProvider>(context, listen: false)
                  .fetchFavorited();
              return Center(child: CircularProgressIndicator());
            },
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: favorited.listLength,
          ),
        );
      },
      selector: (_, up) => up.favorited,
      shouldRebuild: (_, next) => next.isChanged(),
    );
  }

  Widget _listComments() {
    return Selector<UserProvider, ListHolder<Comment>>(
      builder: (context, comments, _) {
        return RefreshIndicator(
          onRefresh:
              Provider.of<UserProvider>(context, listen: false).refreshComments,
          child: ListView.separated(
            itemBuilder: (ctx, i) {
              if (i < comments.length) {
                return CommentItem(comments[i], false);
              }
              Provider.of<UserProvider>(context, listen: false).fetchComments();
              return Center(child: CircularProgressIndicator());
            },
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: comments.listLength,
          ),
        );
      },
      selector: (_, up) => up.comments,
      shouldRebuild: (_, next) => next.isChanged(),
    );
  }
}
