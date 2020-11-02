import 'package:flutter_blog/models/role.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String image;
  final Role role;

  User({this.id, this.name, this.email, this.image, this.role});

  User.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        name = parsed['name'],
        email = parsed['email'],
        image = parsed['image'],
        role = Role.fromJson(parsed['role']);
}
