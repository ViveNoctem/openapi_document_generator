import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

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
}) implements IDocumentNode {
  @override
  IDocumentNode merge(IDocumentNode other) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/schema";
    var errors = ValidationErrors([]);

    if (properties?.values case final notNull?) {
      for (final schema in notNull) {
        final schemaResult = schema.validate(path);

        switch (schemaResult) {
          case FailureOf<void, ValidationErrors>():
            errors = errors.merge(schemaResult.failure);
          case SuccessOf<void, ValidationErrors>():
            break;
        }
      }
    }

    if (errors.validations.isNotEmpty) {
      return FailureOf(errors);
    }

    return SuccessOf(null);
  }

  factory OpenApiSchemaContent.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSchemaContentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiSchemaContentToJson(this);
}

@JsonSerializable()
class const OpenapiMediaType({
  final OpenApiSchemaContent? schema,
  final dynamic example,
}) implements IDocumentNode {
  factory OpenapiMediaType.fromJson(Map<String, dynamic> json) =>
      _$OpenapiMediaTypeFromJson(json);
  Map<String, dynamic> toJson() => _$OpenapiMediaTypeToJson(this);

  @override
  IDocumentNode merge(IDocumentNode other) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/mediatype";
    var errors = ValidationErrors([]);
    if (schema case final notNull?) {
      final schemaResult = notNull.validate(path);

      switch (schemaResult) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(schemaResult.failure);
        case SuccessOf<void, ValidationErrors>():
      }
    }

    if (errors.validations.isNotEmpty) {
      return FailureOf(errors);
    }

    return SuccessOf(null);
  }
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
