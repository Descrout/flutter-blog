import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/views/landing.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (ctx) => Landing());
      default:
        return MaterialPageRoute(builder: (ctx) => Landing());
    }
  }
}
