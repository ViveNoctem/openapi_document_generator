import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_content.dart';

part 'open_api_components.g.dart';

@JsonSerializable()
class const OpenApiComponents({
  @JsonKey(includeToJson: false, includeFromJson: false)
  final Set<DartType>? types,
  final Map<String, OpenApiSchemaContent>? schemas,
}) {
  factory OpenApiComponents.fromJson(Map<String, dynamic> json) =>
      _$OpenApiComponentsFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiComponentsToJson(this);
}
