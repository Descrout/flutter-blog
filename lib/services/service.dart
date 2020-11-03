import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/utils/query_params.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIResponse<T> {
  final T data;
  final bool error;
  final String errorMsg;
  APIResponse({this.data, this.errorMsg, this.error = false});
}

class Service {
  final String endpoint;
  QueryParams params;
  Service(this.endpoint) : params = QueryParams();

  Future<APIResponse<List>> getItems() async {
    var uri = Uri.http(Constants.SERVER, this.endpoint, this.params.getAll());
    var res = await http.get(uri);

    if (res.statusCode == 200) {
      var items = convert.jsonDecode(res.body) as List;
      return APIResponse(data: items);
    }
    var error = convert.jsonDecode(res.body);
    return APIResponse(
        error: true, errorMsg: error['status'] ?? 'Cannot get items.');
  }
}
