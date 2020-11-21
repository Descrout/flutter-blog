import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.User,
                arguments: Globals.shared.user.id);
          },
          leading: Icon(Icons.person),
          title: Text('Profile'),
        ),
        ListTile(
          onTap: () {
            context.read<AuthProvider>().logout();
            context.read<ListProvider<Article>>().refresh();
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.logout),
          title: Text('Logout'),
        ),
      ],
    );
  }

  Widget header() {
    return DrawerHeader(
      child: Container(),
      decoration: BoxDecoration(
        color: Colors.indigo,
        image: DecorationImage(
            image: NetworkImage(Globals.shared.user.getImageURL),
            fit: BoxFit.cover),
      ),
    );
  }
}
