import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:flutter_blog/views/article_page.dart';
import 'package:flutter_blog/views/landing_page.dart';
import 'package:flutter_blog/views/login_page.dart';
import 'package:flutter_blog/views/users_page.dart';
import 'package:provider/provider.dart';

abstract class Routes {
  static const Landing = '/';
  static const Login = '/login';
  static const Users = '/users';
  static const Contact = '/contact';
  static const Article = '/article';
  static const User = '/user';

  static const KEYNAMES = [
    Routes.Landing,
    Routes.Users,
    Routes.Contact,
  ];

  static final _routes = {
    Landing: LandingPage(),
    Users: UsersPage(),
    Login: LoginPage(),
  };

  static MaterialPageRoute generate(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) {
        switch (settings.name) {
          case Article:
            return ChangeNotifierProvider(
              create: (ctx) => ArticleProvider(settings.arguments as int),
              child: ArticlePage(),
            );
          default:
            return _routes[settings.name];
        }
      });
}
