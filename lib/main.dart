import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';

import 'models/article.dart';
import 'models/user.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  final articleProvider = ListProvider<Article>("/api/articles");
  final userProvider = ListProvider<User>("/api/users");

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (ctx) => AuthProvider(articleProvider, userProvider)),
        ChangeNotifierProvider(create: (ctx) => articleProvider),
        ChangeNotifierProvider(create: (ctx) => userProvider),
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
