import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

part 'open_api_content.g.dart';

@JsonSerializable()
class const OpenApiSchemaContent({
  final OpenApiSchemaType? type,
  @JsonKey(name: "\$ref") final String? ref,
  final List<String>? required,
  final String? format,
  final Map<String, OpenApiSchemaContent>? properties,
  @JsonKey(name: "enum") final List<String>? enumVal,
  final dynamic example,
  @JsonKey(includeToJson: false, includeFromJson: false)
  final DartType? dartType,
}) implements ISpecNode {
  @override
  ISpecNode merge(ISpecNode other) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    // TODO: implement validate
    throw UnimplementedError();
  }

  factory OpenApiSchemaContent.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSchemaContentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiSchemaContentToJson(this);
}

@JsonSerializable()
class const OpenApiContent(
  final OpenApiSchemaContent schema,
  final dynamic example,
) {
  factory OpenApiContent.fromJson(Map<String, dynamic> json) =>
      _$OpenApiContentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiContentToJson(this);
}

// TODO snake_case to
enum OpenApiSchemaType {
  object,
  integer,
  string,
  number,
  @JsonValue("null")
  nullVal,
  boolean,
  array,
}
