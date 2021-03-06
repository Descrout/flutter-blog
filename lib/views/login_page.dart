import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/request_dialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validation = Provider.of<ValidationProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Blog Login',
            textAlign: TextAlign.center,
            style: Styles.h1,
          ),
          SizedBox(height: 40.0),
          TextFormField(
            initialValue: validation.mail.data,
            keyboardType: TextInputType.emailAddress,
            onChanged: validation.checkMail,
            decoration: Styles.input.copyWith(
                hintText: 'E-Mail',
                labelText: 'E-Mail',
                errorText: validation.mail.error),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            initialValue: validation.password.data,
            obscureText: true,
            onChanged: validation.checkPassword,
            decoration: Styles.input.copyWith(
                hintText: 'Password',
                labelText: 'Password',
                errorText: validation.password.error),
          ),
          SizedBox(height: 15.0),
          RaisedButton(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text('Log In', style: TextStyle(color: Colors.white)),
            ),
            onPressed: validation.isLoginValid(() async {
              context
                  .read<AuthProvider>()
                  .login(validation.mail.data, validation.password.data);
              if (await _showMyDialog(context)) {
                validation.clearLogin();
                context.read<ListProvider<Article>>().refresh();
                Navigator.of(context).pushReplacementNamed(Routes.Landing);
              }
            }),
          ),
          SizedBox(height: 15.0),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.Register);
            },
            child: Text("Create an account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  Future<bool> _showMyDialog(BuildContext ctx) async {
    return showDialog<bool>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (ctx) => RequestDialog(),
    );
  }
}
