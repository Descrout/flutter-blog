import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/role.dart';
import 'package:flutter_blog/utils/time.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String image;
  final UnixTime createdAt;
  final int karma;
  final Role role;

  User(
      {this.id,
      this.name,
      this.email,
      this.image,
      this.createdAt,
      this.karma,
      this.role});

  String get getImageURL => 'http://${Globals.SERVER}${image}';

  User.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        name = parsed['name'],
        email = parsed['email'],
        image = parsed['image'],
        createdAt = UnixTime(parsed['created_at']),
        karma = parsed['karma'],
        role = Role.fromJson(parsed['role']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'image': image,
        'created_at': (createdAt.sinceEpoch ?? 0) / 1000,
        'role': role.toJson(),
      };
}
