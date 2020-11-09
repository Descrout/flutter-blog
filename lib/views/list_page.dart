import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/widgets/bottom_nav.dart';
import 'package:flutter_blog/widgets/guest_drawer.dart';
import 'package:flutter_blog/widgets/user_drawer.dart';
import 'package:provider/provider.dart';

class ListPage<T> extends StatelessWidget {
  final _controller = ScrollController();
  final Widget Function(BuildContext, T) builder;
  final Widget filter;
  final Tab tab;
  final String name;

  ListPage({
    Key key,
    @required this.builder,
    @required this.filter,
    @required this.tab,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Globals.TITLE),
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
                icon: const Icon(Icons.person),
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
          controller: _controller,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[_tabBar()];
          },
          body: TabBarView(children: [
            Consumer<ListProvider<T>>(
              builder: (_, items, __) => RefreshIndicator(
                child: _buildItems(context, items),
                onRefresh: items.refresh,
              ),
            ),
            filter,
          ]),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentPage: name,
        onSamePage: _scrollTop,
      ),
    );
  }

  void _scrollTop() {
    _controller.animateTo(
      0,
      duration: Duration(milliseconds: 1500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget _tabBar() {
    return SliverToBoxAdapter(
      child: TabBar(
        onTap: (i) {
          if (i == 0) _scrollTop();
        },
        labelColor: Colors.indigo,
        tabs: [
          tab,
          Tab(text: "Filter", icon: Icon(Icons.filter_list)),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext ctx, ListProvider<T> items) {
    return ListView.separated(
        itemBuilder: (ctx, i) {
          if (i < items.length) {
            return builder(ctx, items.at(i));
          }
          items.extend();
          return Center(child: CircularProgressIndicator());
        },
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: items.listLength);
  }
}
