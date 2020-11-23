import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:flutter_blog/widgets/bottom_nav.dart';
import 'package:flutter_blog/widgets/guest_drawer.dart';
import 'package:flutter_blog/widgets/user_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
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
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (_, user, __) => (user.status == AuthStatus.Authenticated
              ? UserDrawer()
              : GuestDrawer()),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentPage: Routes.Contact,
        onSamePage: () {},
      ),
      body: _contactBody(context),
    );
  }

  Widget _contactBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://avatars1.githubusercontent.com/u/3063434?s=460&u=22ef71e7dfa51f4e1e3bedf8512bd8debd392583&v=4",
                height: 200.0,
                width: 200.0,
              ),
            ),
            SizedBox(height: 16),
            Text("Adil Basar", style: Styles.h1),
            Divider(),
            ListTile(
              onTap: () async {
                const url = 'https://github.com/Descrout';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Cannot launch $url'),
                  ));
                }
              },
              leading: Icon(Icons.code),
              title: Text("github.com/Descrout"),
            ),
            Divider(),
            ListTile(
              onTap: () async {
                final url = Uri(
                    scheme: 'mailto',
                    path: 'adilbasar.dev@gmail.com',
                    queryParameters: {
                      'subject': 'About the flutter blog app.',
                    }).toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Cannot email to $url'),
                  ));
                }
              },
              leading: Icon(Icons.mail),
              title: Text("adilbasar.dev@gmail.com"),
            ),
          ],
        ),
      ),
    );
  }
}
