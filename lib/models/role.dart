class Role {
  final int id;
  final String name;
  final int code;

  Role({this.id, this.name, this.code});

  Role.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'],
        name = parsed['name'],
        code = parsed['code'];
}
