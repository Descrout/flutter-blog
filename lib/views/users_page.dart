import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/widgets/bottom_nav.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/guest_drawer.dart';
import 'package:flutter_blog/widgets/user_drawer.dart';
import 'package:flutter_blog/widgets/user_item.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article App'),
        leading: Builder(builder: (context) {
          return Consumer<AuthProvider>(
            builder: (ctx, auth, _) {
              if (auth.status == AuthStatus.Authenticated) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(Globals.shared.user.getImageURL),
                    ),
                  ),
                  onTap: () => Scaffold.of(context).openDrawer(),
                );
              }
              return IconButton(
                icon: Icon(Icons.person),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          );
        }),
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (_, user, __) => (user.status == AuthStatus.Authenticated
              ? UserDrawer()
              : GuestDrawer()),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: TabBar(
                  labelColor: Colors.indigo,
                  tabs: [
                    Tab(
                        text: "Users",
                        icon: Icon(Icons.supervised_user_circle)),
                    Tab(text: "Filter", icon: Icon(Icons.filter_list)),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(children: [
            Consumer<ListProvider<User>>(
              builder: (_, users, __) => RefreshIndicator(
                  child: _buildUsers(users), onRefresh: users.refresh),
            ),
            Text("USER FILTERS HERE"),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentPage: Routes.Users,
        onSamePage: () {},
      ),
    );
  }

  Widget _buildUsers(ListProvider<User> users) {
    return ListView.separated(
        itemBuilder: (ctx, i) {
          if (i < users.length) {
            return UserItem(users.at(i));
          }
          users.extend();
          return Center(child: CircularProgressIndicator());
        },
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: users.listLength);
  }
}
