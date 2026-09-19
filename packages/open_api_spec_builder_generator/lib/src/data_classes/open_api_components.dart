import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/json/raw_json_converter.dart';

part 'open_api_components.g.dart';

@JsonSerializable()
class const OpenApiComponents({
  @JsonKey(includeToJson: false, includeFromJson: false)
  final Set<DartType>? types,
  @RawJsonStringConverter() final String? schemas,
}) {
  factory OpenApiComponents.fromJson(Map<String, dynamic> json) =>
      _$OpenApiComponentsFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiComponentsToJson(this);
}
