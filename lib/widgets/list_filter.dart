import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/list_provider.dart';
import 'package:provider/provider.dart';

extension on DateTime {
  String noHour() {
    return '${this.day < 10 ? "0" : ""}${this.day}/${this.month < 10 ? "0" : ""}${this.month}/${this.year}';
  }
}

class ListFilter<T> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = context.watch<ListProvider<T>>();
    final _search = TextFormField(
      initialValue: list.search,
      onFieldSubmitted: list.setSearch,
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  "Search",
                  style: TextStyle(fontSize: 18),
                ),
                (list.searchFiltered
                    ? IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.close),
                        onPressed: list.clearSearchFilters,
                      )
                    : SizedBox.shrink())
              ],
            ),
            Divider(),
            _search,
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Order By",
                  style: TextStyle(fontSize: 18),
                ),
                (list.orderFiltered
                    ? IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.close),
                        onPressed: list.clearOrderFilter,
                      )
                    : SizedBox.shrink()),
              ],
            ),
            Divider(),
            SizedBox(height: 20),
            _sortPicker(list),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Date Range",
                  style: TextStyle(fontSize: 18),
                ),
                (list.dateFiltered
                    ? IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.close),
                        onPressed: list.clearDateFilters,
                      )
                    : SizedBox.shrink()),
              ],
            ),
            Divider(),
            SizedBox(height: 20),
            _customDatePicker(context, list),
          ],
        ),
      ),
    );
  }

  Widget _sortItem(IconData icon, String text, double w) {
    return SizedBox(
      width: w - 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Icon(icon), Text(text)],
        ),
      ),
    );
  }

  Widget _sortPicker(ListProvider<T> list) {
    return LayoutBuilder(
      builder: (context, constraints) => ToggleButtons(
        color: Colors.grey[700],
        children: <Widget>[
          _sortItem(Icons.new_releases, "New", constraints.maxWidth / 3),
          _sortItem(Icons.favorite, "Popular", constraints.maxWidth / 3),
          _sortItem(Icons.message, "Reply", constraints.maxWidth / 3),
        ],
        onPressed: list.setOrder,
        isSelected: list.selectedOrder,
      ),
    );
  }

  Widget _customDatePicker(BuildContext context, ListProvider<T> list) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: RaisedButton.icon(
            color: Colors.indigo,
            textColor: Colors.white,
            label: Text(list.params.from.noHour()),
            icon: Icon(Icons.date_range_rounded),
            onPressed: () async {
              await _pickDate(context, true, list);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Icon(Icons.arrow_circle_down, color: Colors.grey[700]),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton.icon(
            color: Colors.indigo,
            textColor: Colors.white,
            label: Text(list.params.to.noHour()),
            icon: Icon(Icons.date_range_rounded),
            onPressed: () async {
              await _pickDate(context, false, list);
            },
          ),
        ),
      ],
    );
  }

  _pickDate(BuildContext context, bool from, ListProvider<T> list) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: from ? list.params.from : list.params.to,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await list.setDate(from, picked);
    }
  }
}
