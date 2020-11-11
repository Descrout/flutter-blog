import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/views/list_filter.dart';
import 'package:flutter_blog/views/list_page.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/user_item.dart';

class UsersPage extends ListPage<User> {
  UsersPage({Key key})
      : super(
          key: key,
          name: Routes.Users,
          builder: (ctx, user) => UserItem(user),
          tab: Tab(text: "Users", icon: Icon(Icons.supervised_user_circle)),
          filter: ListFilter<User>(),
        );
}
