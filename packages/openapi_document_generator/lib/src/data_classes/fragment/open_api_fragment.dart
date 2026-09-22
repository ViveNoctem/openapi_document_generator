import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_path_item.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

part 'open_api_fragment.g.dart';

@JsonSerializable()
final class const OpenApiFragment({
  required final OpenApiPaths paths,
  required final OpenApiComponentsFragment components,
}) implements IDocumentNode {
  factory OpenApiFragment.fromJson(Map<String, dynamic> json) =>
      _$OpenApiFragmentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiFragmentToJson(this);

  @override
  OpenApiFragment merge(IDocumentNode other) {
    if (other is! OpenApiFragment) {
      return this;
    }

    final newPaths = paths;

    for (final MapEntry(:key, :value) in other.paths.entries) {
      final element = newPaths[key];

      // TODO if path merge fails because of get being defined multiple times,
      // TODO components could have more components than actually used
      if (element != null) {
        newPaths[key] = element.merge(value);
      } else {
        newPaths[key] = value;
      }
    }

    final newComponents = components.merge(other.components);

    return OpenApiFragment(paths: newPaths, components: newComponents);
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}
