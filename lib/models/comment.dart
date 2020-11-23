import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/utils/time.dart';

class Comment {
  final int id;
  final int articleID;
  final String body;
  final UnixTime createdAt;
  final UnixTime updatedAt;
  User user;

  Comment(
      {this.id,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.articleID});

  Comment.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        articleID =
            parsed.containsKey('article_id') ? parsed['article_id'] : null,
        body = parsed['body'],
        createdAt = UnixTime(parsed['created_at']),
        updatedAt = UnixTime(parsed['updated_at']),
        user =
            parsed.containsKey('user') ? User.fromJson(parsed['user']) : null;
}
