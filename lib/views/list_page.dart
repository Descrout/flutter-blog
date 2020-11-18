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
  final Widget fButton;

  ListPage({
    Key key,
    @required this.builder,
    @required this.filter,
    @required this.tab,
    @required this.name,
    this.fButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: fButton,
        appBar: AppBar(
          title: const Text(Globals.TITLE),
          leading: Consumer<AuthProvider>(
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
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                );
              }
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              );
            },
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  DefaultTabController.of(context)
                      .animateTo(1, duration: Duration(seconds: 2));
                },
              );
            })
          ],
        ),
        drawer: Drawer(
          child: Consumer<AuthProvider>(
            builder: (_, user, __) => (user.status == AuthStatus.Authenticated
                ? UserDrawer()
                : GuestDrawer()),
          ),
        ),
        body: NestedScrollView(
          controller: _controller,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _tabBar(),
              SliverToBoxAdapter(
                child: Selector<ListProvider<T>, bool>(
                  builder: (context, isFiltered, child) {
                    if (isFiltered) {
                      return ListTile(
                        title: Text("Click to remove all filters",
                            style: TextStyle(color: Colors.white)),
                        onTap:
                            Provider.of<ListProvider<T>>(context, listen: false)
                                .clearFilters,
                        leading: Icon(Icons.close, color: Colors.white),
                        tileColor: Colors.green,
                      );
                    }
                    return SizedBox.shrink();
                  },
                  selector: (context, list) => list.filtered,
                ),
              ),
            ];
          },
          body: TabBarView(children: [
            Consumer<ListProvider<T>>(
              builder: (_, items, __) => RefreshIndicator(
                child: (items.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: 50),
                          Center(
                              child:
                                  Icon(Icons.mood_bad, color: Colors.indigo)),
                          Center(
                              child: Text(
                            "Nothing to show.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.indigo),
                          )),
                        ],
                      )
                    : _buildItems(context, items)),
                onRefresh: items.refresh,
              ),
            ),
            filter,
          ]),
        ),
        bottomNavigationBar: BottomNav(
          currentPage: name,
          onSamePage: _scrollTop,
        ),
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
            return builder(ctx, items[i]);
          }
          items.extend();
          return Center(child: CircularProgressIndicator());
        },
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: items.listLength);
  }
}
