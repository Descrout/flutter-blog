import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/utils/time.dart';

class Article {
  final int id;
  final String title;
  final String body;
  final UnixTime createdAt;
  final UnixTime updatedAt;
  final User user;

  Article(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.user});

  Article.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        title = parsed['title'],
        body = parsed['body'],
        createdAt = UnixTime(parsed['created_at']),
        updatedAt = UnixTime(parsed['updated_at']),
        user = User.fromJson(parsed['user']);
}
