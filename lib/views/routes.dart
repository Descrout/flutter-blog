import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:flutter_blog/providers/comments_provider.dart';
import 'package:flutter_blog/providers/user_provider.dart';
import 'package:flutter_blog/views/article_page.dart';
import 'package:flutter_blog/views/contact_page.dart';
import 'package:flutter_blog/views/update_article.dart';
import 'package:flutter_blog/views/landing_page.dart';
import 'package:flutter_blog/views/login_page.dart';
import 'package:flutter_blog/views/register_page.dart';
import 'package:flutter_blog/views/user_page.dart';
import 'package:flutter_blog/views/users_page.dart';
import 'package:flutter_blog/views/comments_page.dart';
import 'package:provider/provider.dart';

abstract class Routes {
  static const Landing = '/';
  static const Login = '/login';
  static const Register = '/register';
  static const Users = '/users';
  static const User = '/user';
  static const Contact = '/contact';
  static const Article = '/article';
  static const Comments = '/comments';
  static const Update = '/update';

  static const KEYNAMES = [
    Routes.Landing,
    Routes.Users,
    Routes.Contact,
  ];

  static final _routes = {
    Landing: LandingPage(),
    Users: UsersPage(),
    Login: LoginPage(),
    Register: RegisterPage(),
    Contact: ContactPage(),
  };

  static MaterialPageRoute generate(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) {
        switch (settings.name) {
          case Article:
            return ChangeNotifierProvider(
              create: (ctx) => ArticleProvider(settings.arguments),
              child: ArticlePage(),
            );
          case Comments:
            return ChangeNotifierProvider(
              create: (ctx) => CommentsProvider(settings.arguments),
              child: CommentsPage(),
            );
          case User:
            return ChangeNotifierProvider(
              create: (ctx) => UserProvider(settings.arguments),
              child: UserPage(),
            );
          case Update:
            return UpdateArticle(update: settings.arguments);

          default:
            return _routes[settings.name];
        }
      });
}
