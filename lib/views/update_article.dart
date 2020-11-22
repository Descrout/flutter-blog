import 'package:flutter/material.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';

class UpdateArticle extends StatelessWidget {
  final Article update;
  const UpdateArticle({Key key, this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validation = Provider.of<ValidationProvider>(context);

    String buttonText = 'Post';
    String title = 'Create an Article';
    String initTitle = validation.title.data;
    String initBody = validation.body.data;

    if (update != null) {
      title = 'Update the Article';
      initTitle = update.title;
      initBody = update.body;
      buttonText = 'Update';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            TextFormField(
              initialValue: initTitle,
              onChanged: validation.checkTitle,
              decoration: Styles.input.copyWith(
                  hintText: 'Title',
                  labelText: 'Title',
                  errorText: validation.title.error),
            ),
            SizedBox(height: 5),
            TextFormField(
              initialValue: initBody,
              keyboardType: TextInputType.multiline,
              onChanged: validation.checkBody,
              minLines: 15,
              maxLength: 10000,
              maxLines: 100,
              decoration: Styles.input.copyWith(
                  hintText: 'Body',
                  labelText: 'Body',
                  errorText: validation.body.error),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.indigo,
                onPressed: validation.isArticleValid(() async {
                  print(validation.title.data);
                  final article = update != null
                      ? await _editArticle(
                          context, validation.title.data, validation.body.data)
                      : await _postArticle(
                          context, validation.title.data, validation.body.data);
                  if (article.error != null) {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        title: Text("Article Error !"),
                        content: Text(article.error),
                        actions: [
                          TextButton(
                              onPressed: Navigator.of(ctx).pop,
                              child: Text("OK")),
                        ],
                      ),
                    );
                  } else {
                    validation.clearArticleCreation();
                    context.read<ListProvider<Article>>().refresh();
                    Navigator.of(context).pushReplacementNamed(Routes.Article,
                        arguments: article.data);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Item<int>> _editArticle(
      BuildContext ctx, String title, String body) async {
    return showDialog<Item<int>>(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        (ctx) async {
          Navigator.of(ctx).pop(await Blog.editArticle(update.id, title, body));
        }(ctx);
        return AlertDialog(
          title: Text("Updating article..."),
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<Item<int>> _postArticle(
      BuildContext ctx, String title, String body) async {
    return showDialog<Item<int>>(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        (ctx) async {
          Navigator.of(ctx).pop(await Blog.postArticle(title, body));
        }(ctx);
        return AlertDialog(
          title: Text("Posting article..."),
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
