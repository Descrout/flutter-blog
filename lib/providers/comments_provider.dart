import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/utils/query_params.dart';

class CommentsProvider with ChangeNotifier {
  final int articleID;
  List<Comment> _comments = List<Comment>();
  int _lastCount;
  int _page = 1;

  int get length => _comments.length;
  bool get isEmpty => _comments.isEmpty;
  int get listLength => _comments.length + (hasMore ? 1 : 0);
  bool get hasMore => _lastCount == 10;

  String sendError;

  Comment operator [](int i) => _comments[i];

  TextEditingController controller = TextEditingController();

  CommentsProvider(this.articleID) {
    fetch();
  }

  extend() async {
    _page += 1;
    await fetch();
  }

  Future<void> refresh() async {
    _lastCount = 0;
    _page = 1;
    _comments.clear();
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
        "/api/comments/$articleID", QueryParams()..page = _page);
    if (!itemsResponse.success) {
      print('Error while getting a comment page : ${itemsResponse.error}');
      return;
    }

    _lastCount = itemsResponse.data.length;
    _comments.addAll(itemsResponse.data);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
