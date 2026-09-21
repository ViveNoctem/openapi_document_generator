import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_path_item.dart';

part 'open_api_fragment.g.dart';

@JsonSerializable()
final class const OpenApiFragment({
  required final OpenApiPaths paths,
  required final OpenApiComponentsFragment components,
}) {
  factory OpenApiFragment.fromJson(Map<String, dynamic> json) =>
      _$OpenApiFragmentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiFragmentToJson(this);
}
