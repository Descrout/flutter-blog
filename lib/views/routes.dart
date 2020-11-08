import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/views/landing_page.dart';
import 'package:flutter_blog/views/login_page.dart';
import 'package:flutter_blog/views/users_page.dart';

abstract class Routes {
  static const Landing = '/';
  static const Login = '/login';
  static const Users = '/users';
  static const Contact = '/contact';

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
      MaterialPageRoute(builder: (_) => _routes[settings.name]);
}
