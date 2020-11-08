import 'package:flutter/widgets.dart';
import 'package:flutter_blog/models/model_json.dart';
import 'package:flutter_blog/services/service.dart';
import 'package:flutter_blog/utils/query_params.dart';

class ListProvider<T> with ChangeNotifier {
  final Service service;
  final int itemCapacity;

  List<T> _items = List<T>();
  int _lastCount;
  QueryParams params = QueryParams();

  ListProvider({@required String endpoint, @required this.itemCapacity})
      : service = Service(endpoint) {
    this._add();
  }

  int get length => _items.length;
  int get listLength => _items.length + (this.hasMore ? 1 : 0);
  bool get hasMore => _lastCount == itemCapacity;
  T at(int i) => _items[i];

  Future<void> refresh() async {
    params.page = 0;
    _items.clear();
    await this._add();
    notifyListeners();
  }

  void extend() {
    params.page += 1;
    this._add();
  }

  Future<void> _add() async {
    final itemsResponse = await service.getMultiple(params);
    if (itemsResponse.success) {
      this._lastCount = itemsResponse.data.length;
      _items.addAll(
          itemsResponse.data.map<T>((item) => fromJson<T>(item)).toList());
      notifyListeners();
    }
  }
}
