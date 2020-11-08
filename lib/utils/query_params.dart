enum SortType { POPULAR, COMMENT, NEW }

class QueryParams {
  int page = 1;
  String search = "";
  SortType sort;
  int _from = 0;
  int _to = 0;
  bool excludeUser = false;

  set from(DateTime from) =>
      this._from = from.toUtc().millisecondsSinceEpoch ~/ 1000;

  set to(DateTime to) => this._to = to.toUtc().millisecondsSinceEpoch ~/ 1000;

  String get date => "$_from|$_to";

  Map<String, String> getAll() {
    var params = {"page": this.page.toString()};

    if (this.search != "") {
      params["search"] = this.search;
    }

    if (this._to > 0) {
      params["date"] = this.date;
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

    if (this.excludeUser) {
      params["user"] = "0";
    }

    return params;
  }
}
