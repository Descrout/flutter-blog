import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/utils/time.dart';

class Comment {
  final int id;
  final String body;
  final UnixTime createdAt;
  final UnixTime updatedAt;
  final User user;

  Comment({this.id, this.body, this.createdAt, this.updatedAt, this.user});

  Comment.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        body = parsed['body'],
        createdAt = UnixTime(parsed['created_at']),
        updatedAt = UnixTime(parsed['updated_at']),
        user = User.fromJson(parsed['user']);
}
