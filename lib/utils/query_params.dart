class QueryParams {
  int page = 1;
  String search = "";
  int _from = 0;
  int _to = 0;

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

    return params;
  }
}
