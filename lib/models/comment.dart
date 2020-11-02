import 'package:flutter_blog/models/user.dart';

class Comment {
  final int id;
  final String body;
  final int created_at; // DateTime.now().toUtc().millisecondsSinceEpoch
  final int updated_at;
  final User user;

  Comment({this.id, this.body, this.created_at, this.updated_at, this.user});

  Comment.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        body = parsed['body'],
        created_at = parsed['created_at'],
        updated_at = parsed['updated_at'],
        user = User.fromJson(parsed['user']);
}
