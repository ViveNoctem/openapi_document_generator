import 'dart:convert';

import 'package:analyzer/dart/element/type.dart';

class const ContentUtils() {
  String? getJsonForContentType(DartType? type) {
    if (type == null) {
      return null;
    }

    final json = <String, dynamic>{};

    if (type.isDartCoreBool) {
      json["type"] = "boolean";
    } else if (type.isDartCoreInt) {
      json["type"] = "integer";
    } else if (type.isDartCoreString) {
      json["type"] = "string";
    } else if (type.isDartCoreDouble) {
      json["type"] = "number";
    } else if (type.isDartCoreNull) {
      json["type"] = "null";
    } else if (type.isDartCoreList) {
      throw UnimplementedError("List as a parameter Type not supported");
    } else {
      json["\$ref"] = "#/components/schemas/${type.element?.displayName}";
    }

    return jsonEncode(json);
  }
}
