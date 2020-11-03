import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/services/service.dart';

class UserService extends Service {
  UserService() : super("/api/users");

  Future<APIResponse<List<User>>> getUsers() async {
    var res = await super.getItems();
    if (res.error) return res;

    return APIResponse(
        data: res.data.map((user) => User.fromJson(user)).toList());
  }
}
