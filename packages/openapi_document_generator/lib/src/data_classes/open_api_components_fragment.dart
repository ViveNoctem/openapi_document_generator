import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';

part 'open_api_components_fragment.g.dart';

@JsonSerializable()
class const OpenApiComponentsFragment({
  required final Set<DartTypeJson> schemas,
}) {
  factory OpenApiComponentsFragment.fromJson(Map<String, dynamic> json) =>
      _$OpenApiComponentsFragmentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiComponentsFragmentToJson(this);
}
