import 'package:flutter/material.dart';

class Role {
  final int id;
  final String name;
  final int code;

  Role({this.id, this.name, this.code});

  Color get color {
    switch (id) {
      case 1:
        return Colors.orangeAccent;
      case 2:
        return Colors.orange;
      default:
        return Colors.deepOrange;
    }
  }

  Role.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        name = parsed['name'],
        code = parsed['code'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}
