import 'package:flutter/material.dart';
import 'package:flutter_blog/blog_api.dart';

enum EditType { DELETE, UPDATE }

class EditItem<T> extends StatelessWidget {
  final String endpoint;
  final String what;
  final VoidCallback onRemoveSuccess;
  final void Function(T) onUpdate;
  const EditItem(
      {Key key,
      @required this.endpoint,
      @required this.what,
      @required this.onUpdate,
      @required this.onRemoveSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final type = await _showPicker(context);
        if (type == EditType.DELETE) {
          final error = await Blog.deleteSingle(endpoint);
          if (error == null) onRemoveSuccess();
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(error ?? '$what removed successfuly.')));
        } else if (type == EditType.UPDATE) {
          final tempArticle = await Blog.getSingle<T>(endpoint);
          if (tempArticle.success) onUpdate(tempArticle.data);
        }
      },
      child: Icon(Icons.edit),
    );
  }

  Future<EditType> _showPicker(context) {
    return showModalBottomSheet<EditType>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                      onTap: () {
                        Navigator.of(context).pop(EditType.UPDATE);
                      }),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    onTap: () {
                      Navigator.of(context).pop(EditType.DELETE);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
