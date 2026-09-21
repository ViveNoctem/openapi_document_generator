import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_parameter.dart';

part 'openapi_path_item.g.dart';

@JsonSerializable()
class const OpenapiPathItem({
  @JsonKey(name: '\$ref') final String? ref,
  final String? summary,
  final String? description,
  final InternOpenApiOperation? get,
  final InternOpenApiOperation? put,
  final InternOpenApiOperation? post,
  final InternOpenApiOperation? delete,
  final InternOpenApiOperation? options,
  final InternOpenApiOperation? head,
  final InternOpenApiOperation? patch,
  final InternOpenApiOperation? trace,
  final List<InternOpenApiParameter>? parameters,
}) {
  factory OpenapiPathItem.fromJson(Map<String, dynamic> json) =>
      _$OpenapiPathItemFromJson(json);
  Map<String, dynamic> toJson() => _$OpenapiPathItemToJson(this);
}
