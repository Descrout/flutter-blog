enum SortType { NEW, POPULAR, COMMENT }

class QueryParams {
  int page = 1;
  String search = "";
  SortType sort = SortType.NEW;
  DateTime from = DateTime(2020);
  DateTime to = DateTime.now();
  bool dateFiltered = false;

  int get fromUnix => from.toUtc().millisecondsSinceEpoch ~/ 1000;
  int get toUnix => to.toUtc().millisecondsSinceEpoch ~/ 1000;

  clearSearch() {
    search = "";
  }

  clearDates() {
    from = DateTime(2020);
    to = DateTime.now();
    dateFiltered = false;
  }

  clearOrder() {
    sort = SortType.NEW;
  }

  clearFilters() {
    page = 1;
    clearOrder();
    clearDates();
    clearSearch();
  }

  Map<String, String> getAll() {
    var params = {"page": page.toString()};

    if (search != "") {
      params["search"] = search;
    }

    if (dateFiltered) {
      params["date"] = "$fromUnix|$toUnix";
    }

    switch (sort) {
      case SortType.POPULAR:
        params["sort"] = "popular";
        break;
      case SortType.COMMENT:
        params["sort"] = "comment";
        break;
      default:
        break;
    }

    return params;
  }
}
