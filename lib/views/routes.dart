import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/views/landing_page.dart';
import 'package:flutter_blog/views/login_page.dart';

abstract class Routes {
  static const Landing = '/';
  static const Login = '/login';

  static final _routes = {
    Landing: LandingPage(),
    Login: LoginPage(),
  };

  static MaterialPageRoute generate(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => _routes[settings.name]);
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_blog/views/landing_page.dart';
// import 'package:flutter_blog/views/login_page.dart';

// abstract class Routes {
//   static const Landing = '/';
//   static const Login = '/login';

//   static final _routes = {
//     Landing: () => MaterialPageRoute(builder: (ctx) => LandingPage()),
//     Login: () => MaterialPageRoute(builder: (ctx) => LoginPage()),
//   };

//   static MaterialPageRoute generate(RouteSettings settings) =>
//       _routes[settings.name]();
// }
