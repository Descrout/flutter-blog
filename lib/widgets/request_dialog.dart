import 'package:flutter/material.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blog/providers/auth_provider.dart';

class RequestDialog extends StatelessWidget {
  const RequestDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    switch (auth.status) {
      case AuthStatus.Authenticating:
        return Center(child: CircularProgressIndicator());
      case AuthStatus.Authenticated:
        Navigator.of(context).pop(true);
        return Container();
      case AuthStatus.Unauthenticated:
        return AlertDialog(
          title: Text('Login Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${auth.error}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
    }
  }
}
