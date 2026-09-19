import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

class const RawJsonStringConverter()
    implements JsonConverter<String?, dynamic> {
  @override
  String? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return jsonEncode(json);
  }

  @override
  dynamic toJson(String? object) {
    if (object == null) {
      return null;
    }
    return jsonDecode(object);
  }
}
