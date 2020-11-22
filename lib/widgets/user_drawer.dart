import 'package:flutter/material.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/providers/auth_provider.dart';
import 'package:flutter_blog/providers/list_provider.dart';
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
          onTap: () async {
            final res = await _showPicker(context);
            if (res != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                      Text(res.error ?? 'Profile pic successfuly updated.')));
              Navigator.of(context).pop();
            }
          },
          leading: Icon(Icons.image),
          title: Text('Change Profile Pic'),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.User,
                arguments: Globals.shared.user.id);
          },
          leading: Icon(Icons.person),
          title: Text('Profile'),
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
