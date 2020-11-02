import 'package:flutter_blog/models/user.dart';

class Article {
  final int id;
  final String title;
  final String body;
  final int created_at; // DateTime.now().toUtc().millisecondsSinceEpoch
  final int updated_at;
  final User user;

  Article(
      {this.id,
      this.title,
      this.body,
      this.created_at,
      this.updated_at,
      this.user});

  Article.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        title = parsed['title'],
        body = parsed['body'],
        created_at = parsed['created_at'],
        updated_at = parsed['updated_at'],
        user = User.fromJson(parsed['user']);
}
