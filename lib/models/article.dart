import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/utils/time.dart';

class FavResponse {
  final bool favStatus;
  final int favCount;

  FavResponse({this.favCount, this.favStatus});

  FavResponse.fromJson(Map<String, dynamic> parsed)
      : favStatus = parsed['fav_status'],
        favCount = parsed['fav_count'];
}

class Article {
  final int id;
  final String title;
  final String body;
  final UnixTime createdAt;
  final UnixTime updatedAt;
  final int commentCount;
  final int favoriteCount;
  final bool favoriteStatus;
  final bool commentStatus;
  User user;

  Article(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.commentCount,
      this.favoriteCount,
      this.favoriteStatus,
      this.commentStatus,
      this.user});

  Article.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        title = parsed['title'],
        body = parsed['body'],
        createdAt = UnixTime(parsed['created_at']),
        updatedAt = UnixTime(parsed['updated_at']),
        commentCount = parsed['comment_count'],
        favoriteCount = parsed['favorites'],
        favoriteStatus = parsed['fav_status'],
        commentStatus = parsed['comment_status'],
        user =
            parsed.containsKey('user') ? User.fromJson(parsed['user']) : null;
}
