import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/utils/query_params.dart';

class ListProvider<T> with ChangeNotifier {
  final int itemCapacity;
  final String endpoint;

  List<T> _items = List<T>();
  int _lastCount;
  QueryParams params = QueryParams();

  ListProvider(this.endpoint, this.itemCapacity) {
    this._add();
  }

  int get length => _items.length;
  int get listLength => _items.length + (this.hasMore ? 1 : 0);
  bool get hasMore => _lastCount == itemCapacity;
  T at(int i) => _items[i];

  Future<void> refresh() async {
    params.page = 1;
    _items.clear();
    notifyListeners();
    await this._add();
  }

  void extend() {
    params.page += 1;
    this._add();
  }

  Future<void> _add() async {
    final itemsResponse = await Blog.getList<T>(endpoint, params);
    if (!itemsResponse.success) {
      print('Error while adding page to list : ${itemsResponse.error}');
      return;
    }

    this._lastCount = itemsResponse.data.length;
    _items.addAll(itemsResponse.data);
    notifyListeners();
  }
}
