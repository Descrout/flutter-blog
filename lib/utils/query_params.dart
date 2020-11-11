enum SortType { NEW, POPULAR, COMMENT }

class QueryParams {
  int page = 1;
  String search = "";
  SortType sort = SortType.NEW;
  DateTime from = DateTime(2020);
  DateTime to = DateTime.now();

  int get fromUnix => from.toUtc().millisecondsSinceEpoch ~/ 1000;
  int get toUnix => to.toUtc().millisecondsSinceEpoch ~/ 1000;

  clearSearch() {
    page = 1;
    search = "";
  }

  clearDates() {
    from = DateTime(2020);
    to = DateTime.now();
  }

  clearOrder() {
    sort = SortType.NEW;
  }

  clearFilters() {
    page = 1;
    clearOrder();
    clearDates();
  }

  Map<String, String> getAll() {
    var params = {"page": this.page.toString()};

    if (this.search != "") {
      params["search"] = this.search;
    }

    if (this.toUnix > 0) {
      params["date"] = "$fromUnix|$toUnix";
    }

    switch (this.sort) {
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
