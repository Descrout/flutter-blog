import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:flutter_blog/routes.dart';
import 'package:flutter_blog/views/landing.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (ctx) => ArticleProvider())],
        child: MaterialApp(
          title: Constants.TITLE,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Landing(),
          onGenerateRoute: Routes.materialRoutes,
        ));
  }
}
