import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

part 'open_api_components_fragment.g.dart';

@JsonSerializable()
class const OpenApiComponentsFragment({
  required final Set<DartTypeJson> schemas,
}) implements IDocumentNode {
  factory OpenApiComponentsFragment.fromJson(Map<String, dynamic> json) =>
      _$OpenApiComponentsFragmentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiComponentsFragmentToJson(this);

  @override
  OpenApiComponentsFragment merge(IDocumentNode other) {
    if (other is! OpenApiComponentsFragment) {
      return this;
    }

    return OpenApiComponentsFragment(schemas: {...schemas, ...other.schemas});
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}
