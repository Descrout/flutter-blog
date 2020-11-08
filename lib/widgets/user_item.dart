import 'package:flutter/material.dart';
import 'package:flutter_blog/models/role.dart';
import 'package:flutter_blog/models/user.dart';

class UserItem extends StatelessWidget {
  final User user;

  UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      leading: leading(),
      title: Text.rich(TextSpan(text: user.name, children: [
        TextSpan(
          text: ' · ${user.createdAt.passedSinceStr()} old',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        )
      ])),
      subtitle: Text(
        user.email,
        style: TextStyle(fontSize: 11),
      ),
      trailing: role(),
    );
  }

  Widget role() {
    return Chip(
      label: Text(
        user.role.name,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: user.role.color,
    );
  }

  Widget leading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(user.getImageURL),
      ),
    );
  }
}
