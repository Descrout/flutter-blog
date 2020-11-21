import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/utils/list_holder.dart';
import 'package:flutter_blog/utils/query_params.dart';

class UserProvider with ChangeNotifier {
  final int id;
  Item<User> user;
  ListHolder<Article> posted = ListHolder();
  ListHolder<Article> favorited = ListHolder();
  ListHolder<Comment> comments = ListHolder();

  UserProvider(this.id) {
    fetchUser();
  }

  Future<void> refreshPosted() async {
    posted.clear();
    fetchPosted();
  }

  Future<void> refreshFavorited() async {
    favorited.clear();
    fetchFavorited();
  }

  Future<void> refreshComments() async {
    comments.clear();
    fetchComments();
  }

  Future<void> fetchUser() async {
    user = null;
    notifyListeners();
    final userResponse = await Blog.getSingle<User>('/api/users/$id');
    if (!userResponse.success) {
      print('Error while fetching user : ${userResponse.error}');
    } else {
      fetchPosted();
      fetchFavorited();
      fetchComments();
    }
    user = userResponse;
    notifyListeners();
  }

  Future<void> fetchPosted() async {
    final postedResponse = await Blog.getList<Article>(
        '/api/users/$id/articles', QueryParams()..page = posted.page);
    if (!postedResponse.success) {
      print('Error while fetching user articles : ${postedResponse.error}');
      return;
    }
    posted.extend(postedResponse.data.map((a) => a..user = user.data).toList());
    notifyListeners();
  }

  Future<void> fetchFavorited() async {
    final favoritedResponse = await Blog.getList<Article>(
        '/api/users/$id/favorites', QueryParams()..page = favorited.page);
    if (!favoritedResponse.success) {
      print(
          'Error while fetching user favorited articles : ${favoritedResponse.error}');
      return;
    }
    favorited.extend(favoritedResponse.data);
    notifyListeners();
  }

  Future<void> fetchComments() async {
    final commentsResponse = await Blog.getList<Comment>(
        '/api/users/$id/comments', QueryParams()..page = comments.page);
    if (!commentsResponse.success) {
      print('Error while fetching user comments : ${commentsResponse.error}');
      return;
    }
    comments
        .extend(commentsResponse.data.map((c) => c..user = user.data).toList());
    notifyListeners();
  }
}
