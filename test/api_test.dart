import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/utils/query_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Articles Blog API', () {
    test('getList should give results.', () async {
      final articles =
          await Blog.getList<Article>("/api/articles", QueryParams());

      expect(articles.success, true);
    });
  });
}
