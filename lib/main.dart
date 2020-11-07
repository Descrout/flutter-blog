import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/providers/article_provider.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ArticleProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
      ],
      child: materialApp(),
    );
  }

  materialApp() {
    return MaterialApp(
      title: Globals.TITLE,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.Landing,
      onGenerateRoute: Routes.generate,
    );
  }
}
