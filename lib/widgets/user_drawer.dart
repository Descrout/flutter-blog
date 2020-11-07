import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
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
            context.read<AuthProvider>().logout();
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
      child: Center(
        child: Image.network('${Globals.SERVER}${Globals.shared.user.image}'),
      ),
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
    );
  }
}
