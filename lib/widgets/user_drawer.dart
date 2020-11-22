import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.User,
                arguments: Globals.shared.user.id);
          },
          leading: Icon(Icons.person),
          title: Text.rich(
            TextSpan(
              text: Globals.shared.user.name,
              children: [
                TextSpan(
                  text: ' · ${Globals.shared.user.role.name}',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                )
              ],
            ),
          ),
          subtitle: Text(Globals.shared.user.email),
        ),
        Divider(),
        ListTile(
          onTap: () async {
            final res = await _showNameChanger(context);
            if (res != null) {
              if (res.success) {
                context.read<ListProvider<Article>>().refresh();
                context.read<ListProvider<User>>().refresh();
              }
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(res.error ?? 'Name changed successfuly.')));
              Navigator.of(context).pop();
            }
          },
          leading: Icon(Icons.text_fields),
          title: Text('Change Name'),
        ),
        ListTile(
          onTap: () async {
            final res = await _showPicker(context);
            if (res != null) {
              if (res.success) {
                context.read<ListProvider<User>>().refresh();
              }
              Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                      Text(res.error ?? 'Profile pic successfuly updated.')));
              Navigator.of(context).pop();
            }
          },
          leading: Icon(Icons.image),
          title: Text('Change Picture'),
        ),
        ListTile(
          onTap: () {
            context.read<AuthProvider>().logout();
            context.read<ListProvider<Article>>().refresh();
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.logout),
          title: Text('Logout'),
        ),
      ],
    );
  }

  Widget header() {
    return DrawerHeader(
      child: Container(),
      decoration: BoxDecoration(
        color: Colors.indigo,
        image: DecorationImage(
            image: NetworkImage(Globals.shared.user.getImageURL),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Item<User>> _showNameChanger(context) {
    final nameController = TextEditingController();
    return showDialog<Item<User>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (ctx) => AlertDialog(
        title: Text("Type new name : "),
        content: TextField(
          controller: nameController,
          decoration: Styles.input,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final name = nameController.text;
                if (name == null || name == "") return;
                final res = await ctx.read<AuthProvider>().changeName(name);
                Navigator.of(ctx).pop(res);
              },
              child: Text("OK")),
        ],
      ),
    );
  }

  Future<Item<User>> _showPicker(context) {
    return showModalBottomSheet<Item<User>>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () async {
                        final pickedImage = await ImagePicker().getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (pickedImage == null) return;
                        final res = await context
                            .read<AuthProvider>()
                            .changePicture(pickedImage.path);
                        Navigator.of(context).pop(res);
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () async {
                      final pickedImage = await ImagePicker().getImage(
                          source: ImageSource.camera, imageQuality: 50);
                      if (pickedImage == null) return;
                      final res = await context
                          .read<AuthProvider>()
                          .changePicture(pickedImage.path);
                      Navigator.of(context).pop(res);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
