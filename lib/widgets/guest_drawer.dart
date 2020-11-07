import 'package:flutter/material.dart';
import 'package:flutter_blog/views/routes.dart';

class GuestDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.Login);
          },
          leading: Icon(Icons.login),
          title: Text('Login'),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.app_registration),
          title: Text('Register'),
        ),
      ],
    );
  }

  Widget header() {
    return const DrawerHeader(
      child: Center(
        child: Icon(Icons.person, color: Colors.white, size: 100),
      ),
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
    );
  }
}
