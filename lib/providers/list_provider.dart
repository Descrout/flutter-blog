import 'package:flutter/widgets.dart';
import 'package:flutter_blog/blog_api.dart';
import 'package:flutter_blog/utils/query_params.dart';

class ListProvider<T> with ChangeNotifier {
  final int _itemCapacity;
  final String _endpoint;

  List<T> _items = List<T>();
  int _lastCount;
  QueryParams _params = QueryParams();
  bool _dateFiltered = false;
  bool _orderFiltered = false;

  ListProvider(this._endpoint, this._itemCapacity) {
    _add();
  }

  bool get dateFiltered => _dateFiltered;
  bool get orderFiltered => _orderFiltered;
  bool get filtered => _dateFiltered || _orderFiltered;
  int get length => _items.length;
  int get listLength => _items.length + (this.hasMore ? 1 : 0);
  bool get hasMore => _lastCount == _itemCapacity;
  QueryParams get params => _params;
  List<bool> get selectedOrder =>
      SortType.values.map((e) => _params.sort == e).toList();
  T at(int i) => _items[i];

  clearDateFilters() async {
    _params.clearDates();
    _dateFiltered = false;
    await refresh();
  }

  clearOrderFilter() async {
    _params.clearOrder();
    _orderFiltered = false;
    await refresh();
  }

  clearFilters() async {
    _params.clearFilters();
    _dateFiltered = false;
    _orderFiltered = false;
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
    _dateFiltered = true;
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
    await _add();
  }

  Future<void> refresh() async {
    this._lastCount = 0;
    _params.page = 1;
    _items.clear();
    notifyListeners();
    await _add();
  }

  Future<void> _add() async {
    final itemsResponse = await Blog.getList<T>(_endpoint, _params);
    if (!itemsResponse.success) {
      print('Error while adding page to list : ${itemsResponse.error}');
      return;
    }

    this._lastCount = itemsResponse.data.length;
    _items.addAll(itemsResponse.data);
    notifyListeners();
  }
}
