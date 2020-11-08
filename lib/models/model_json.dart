import 'article.dart';
import 'user.dart';

T fromJson<T>(Map<String, dynamic> json) {
  if (T == Article) {
    return Article.fromJson(json) as T;
  } else if (T == User) {
    return User.fromJson(json) as T;
  }
  throw "Invalid model type $T";
}
