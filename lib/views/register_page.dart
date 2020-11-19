import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/request_dialog.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validation = Provider.of<ValidationProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Flutter Blog App',
            textAlign: TextAlign.center,
            style: Styles.h1,
          ),
          SizedBox(height: 40.0),
          TextFormField(
            keyboardType: TextInputType.name,
            onChanged: validation.checkName,
            decoration: Styles.input.copyWith(
                hintText: 'Name',
                labelText: 'Name',
                errorText: validation.name.error),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: validation.checkMail,
            decoration: Styles.input.copyWith(
                hintText: 'E-Mail',
                labelText: 'E-Mail',
                errorText: validation.mail.error),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            obscureText: true,
            onChanged: validation.checkPassword,
            decoration: Styles.input.copyWith(
                hintText: 'Password',
                labelText: 'Password',
                errorText: validation.password.error),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            obscureText: true,
            onChanged: validation.checkRePassword,
            decoration: Styles.input.copyWith(
                hintText: 'Re-Password',
                labelText: 'Re-Password',
                errorText: validation.rePassword.error),
          ),
          SizedBox(height: 15.0),
          RaisedButton(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text('Register', style: TextStyle(color: Colors.white)),
            ),
            onPressed: validation.isRegisterValid(() async {
              final error = await _register(context, validation.name.data,
                  validation.mail.data, validation.password.data);
              if (error != null) {
                showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => AlertDialog(
                    title: Text("Cannot create an account !"),
                    content: Text(error),
                    actions: [
                      TextButton(
                          onPressed: Navigator.of(ctx).pop, child: Text("OK")),
                    ],
                  ),
                );
              } else {
                validation.clearRegister();
                context.read<ListProvider<User>>().refresh();
                Navigator.of(context).pushReplacementNamed(Routes.Login);
              }
            }),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Future<String> _register(
      BuildContext ctx, String name, String mail, String password) async {
    return showDialog<String>(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        (ctx) async {
          Navigator.of(ctx).pop(await Blog.register(name, mail, password));
        }(ctx);
        return AlertDialog(
          title: Text("Creating account..."),
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

//register(validation.name.data,validation.mail.data, validation.password.data);
