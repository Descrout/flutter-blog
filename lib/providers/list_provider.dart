import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/models/article.dart';
import 'package:flutter_blog/utils/query_params.dart';

class ListProvider<T> with ChangeNotifier {
  final int _itemCapacity;
  final String _endpoint;

  List<T> _items = List<T>();
  int _lastCount;
  QueryParams _params = QueryParams();
  bool _orderFiltered = false;
  bool _searchFiltered = false;

  ListProvider(this._endpoint, this._itemCapacity);

  bool get dateFiltered => _params.dateFiltered;
  bool get orderFiltered => _orderFiltered;
  bool get searchFiltered => _searchFiltered;
  String get search => _params.search;
  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;
  QueryParams get params => _params;

  bool get filtered =>
      _params.dateFiltered || _orderFiltered || _searchFiltered;

  int get listLength => _items.length + (hasMore ? 1 : 0);

  bool get hasMore => _lastCount == _itemCapacity;

  List<bool> get selectedOrder =>
      SortType.values.map((e) => _params.sort == e).toList();

  T operator [](int i) => _items[i];

  clearSearchFilters() async {
    _params.clearSearch();
    _searchFiltered = false;
    await refresh();
  }

  clearDateFilters() async {
    _params.clearDates();
    await refresh();
  }

  clearOrderFilter() async {
    _params.clearOrder();
    _orderFiltered = false;
    await refresh();
  }

  clearFilters() async {
    _params.clearFilters();
    _orderFiltered = false;
    _searchFiltered = false;
    await refresh();
  }

  setSearch(String value) async {
    if (_params.search == value && value == "") return;
    _params.search = value;
    _searchFiltered = true;
    await refresh();
  }

  setDate(bool from, DateTime date) async {
    if (from) {
      if (_params.from == date) return;
      _params.from = date;
    } else {
      if (_params.to == date) return;
      _params.to = date;
    }
    _params.dateFiltered = true;
    await refresh();
  }

  setOrder(int index) async {
    if (_params.sort == SortType.values[index]) return;
    _params.sort = SortType.values[index];
    _orderFiltered = true;
    await refresh();
  }

  extend() async {
    _params.page += 1;
    await fetch();
  }

  Future<void> refresh() async {
    _lastCount = 0;
    _params.page = 1;
    _items.clear();
    return fetch();
  }

  Future<void> fetch() async {
    final itemsResponse = await Blog.getList<T>(_endpoint, _params);
    if (!itemsResponse.success) {
      print('Error while adding page to list : ${itemsResponse.error}');
      return;
    }
    _lastCount = itemsResponse.data.length;
    _items.addAll(itemsResponse.data);
    notifyListeners();
  }
}
