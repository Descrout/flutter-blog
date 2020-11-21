class ListHolder<T> {
  List<T> items = List<T>();

  int _lastCount;
  int get lastCount => _lastCount;

  int _page = 1;
  int get page => _page;

  int get length => items.length;
  bool get isEmpty => items.isEmpty;
  int get listLength => items.length + (hasMore ? 1 : 0);
  bool get hasMore => _lastCount == 10;
  bool _changed = false;

  T operator [](int i) => items[i];

  bool isChanged() {
    if (_changed) {
      _changed = false;
      return true;
    }
    return false;
  }

  void clear() {
    _lastCount = 0;
    _page = 1;
    items.clear();
    _changed = true;
  }

  void extend(List<T> more) {
    _page += 1;
    _lastCount = more.length;
    items.addAll(more);
    _changed = true;
  }
}
