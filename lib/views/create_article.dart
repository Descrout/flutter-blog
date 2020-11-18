import 'package:flutter/material.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:flutter_blog/providers/validation_provider.dart';
import 'package:flutter_blog/utils/styles.dart';
import 'package:flutter_blog/views/routes.dart';
import 'package:provider/provider.dart';

class CreateArticle extends StatelessWidget {
  const CreateArticle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validation = Provider.of<ValidationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Create an Article')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            TextFormField(
              initialValue: validation.title.data,
              onChanged: validation.checkTitle,
              decoration: Styles.input.copyWith(
                  hintText: 'Title',
                  labelText: 'Title',
                  errorText: validation.title.error),
            ),
            SizedBox(height: 5),
            TextFormField(
              initialValue: validation.body.data,
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
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.indigo,
                onPressed: validation.isArticleValid(() async {
                  final article = await _postArticle(
                      context, validation.title.data, validation.body.data);
                  if (article.error != null) {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        title: Text("Cannot post article !"),
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
                    Provider.of<ListProvider<Article>>(context, listen: false)
                        .refresh();
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
