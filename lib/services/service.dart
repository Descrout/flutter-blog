import 'package:flutter_blog/globals.dart';
import 'package:flutter_blog/utils/query_params.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Service {
  final String endpoint;

  Service(this.endpoint);

  Future<Item<List<dynamic>>> getMultiple(QueryParams params) async {
    final uri = Uri.http(Globals.SERVER, endpoint, params.getAll());
    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Globals.shared.token}',
    });

    final parsed = convert.jsonDecode(res.body);
    if (res.statusCode == 200) {
      return Item(data: parsed as List<dynamic>);
    }
    return Item(error: parsed['error'] ?? 'Cannot get $endpoint.');
  }

  Future<Item<dynamic>> getSingle() {
    return Future.value(Item(error: "Not implemented yet"));
  }
}
