import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/utils/list_holder.dart';
import 'package:flutter_blog/utils/query_params.dart';

class CommentsProvider with ChangeNotifier {
  final int articleID;
  ListHolder<Comment> items = ListHolder();
  String sendError;

  TextEditingController controller = TextEditingController();

  CommentsProvider(this.articleID) {
    fetch();
  }

  Future<void> refresh() async {
    items.clear();
    await fetch();
  }

  Future<void> sendComment(BuildContext ctx, String msg) async {
    if (msg.length < 1) {
      sendError = "Can't be empty";
      notifyListeners();
      return;
    } else if (Globals.shared.token == null) {
      sendError = "You must login to send a comment.";
      notifyListeners();
      return;
    }

    final comment = await Blog.sendComment(ctx, articleID, msg);
    controller.clear();

    if (comment.success) {
      sendError = null;
      await refresh();
    } else {
      sendError = comment.error;
      notifyListeners();
    }
  }

  Future<void> fetch() async {
    final itemsResponse = await Blog.getList<Comment>(
        "/api/comments/$articleID", QueryParams()..page = items.page);
    if (!itemsResponse.success) {
      print('Error while getting a comment page : ${itemsResponse.error}');
      return;
    }
    items.extend(itemsResponse.data);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
