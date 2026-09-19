import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder/open_api_spec_builder.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/json/raw_json_converter.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

part 'open_api_parameter.g.dart';

@JsonSerializable()
class InternOpenApiParameter({
  final String? name,
  @JsonKey(
    name: "in",
    fromJson: _externalEnumFromJson,
    toJson: _externalEnumToJson,
  )
  final OpenApiParameterLocation? location,
  final String? description,
  final bool? required,
  final bool? deprecated,
  var (String, String)? schemaImportUri,
  @RawJsonStringConverter() final String? schema,
  final String? content,
  // TODO example
}) implements ISpecNode {
  InternOpenApiParameter.withDefault({
    String? name,
    @JsonKey(
      name: "in",
      fromJson: _externalEnumFromJson,
      toJson: _externalEnumToJson,
    )
    OpenApiParameterLocation? location,
    String? description,
    bool? required,
    bool? deprecated,
    (String, String)? schemaImportUri,
    String? schema,
    String? content,
  }) : this(
         location: location,
         deprecated: deprecated ?? false,
         required: required ?? false,
         description: description,
         name: name,
         schemaImportUri: schemaImportUri,
         schema: schema,
         content: content,
       );

  @override
  InternOpenApiParameter merge(ISpecNode other) {
    if (other is! InternOpenApiParameter) {
      return this;
    }
    final String? mergedContent;

    if (schema != null) {
      mergedContent = null;
    } else {
      mergedContent = content ?? other.content;
    }

    final (String, String)? mergedSchemaImportUri;
    final String? mergedSchema;

    if (content != null) {
      mergedSchemaImportUri = null;
      mergedSchema = null;
    } else {
      mergedSchemaImportUri = schemaImportUri ?? other.schemaImportUri;
      // TODO potentially merge both schema string
      mergedSchema = schema ?? other.schema;
    }

    return InternOpenApiParameter(
      name: this.name ?? other.name,
      description: description ?? other.description,
      required: required ?? other.required,
      deprecated: deprecated ?? other.deprecated,
      location: location ?? other.location,
      content: mergedContent,
      schemaImportUri: mergedSchemaImportUri,
      schema: mergedSchema,
    );
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/parameter";

    var errors = ValidationErrors([]);

    if (name == null) {
      errors.validations.add(
        ValidationEntry(
          path: path,
          error: 'field "name" is required in parameter',
        ),
      );
    }

    if (name != null) {
      path = path + "/$name";
    }

    if (required == null) {
      errors.validations.add(
        ValidationEntry(
          path: path,
          error: 'field "required" is required in parameter',
        ),
      );
    }

    if (deprecated == null) {
      errors.validations.add(
        ValidationEntry(
          path: path,
          error: 'field "deprecated" is required in parameter',
        ),
      );
    }

    if (location == null) {
      errors.validations.add(
        ValidationEntry(path: path, error: "location is required"),
      );
    }

    if (content == null && schema == null) {
      errors.validations.add(
        ValidationEntry(
          path: path,
          error: "either content or schema is required",
        ),
      );
    }

    if (content != null && schema != null) {
      errors.validations.add(
        ValidationEntry(
          path: path,
          error: "both content and schema are set, one must be null",
        ),
      );
    }

    if (errors.validations.isNotEmpty) {
      return FailureOf(errors);
    }

    return SuccessOf(null);
  }

  factory InternOpenApiParameter.fromJson(Map<String, dynamic> json) =>
      _$InternOpenApiParameterFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenApiParameterToJson(this);
}

OpenApiParameterLocation? _externalEnumFromJson(String? json) =>
    OpenApiParameterLocation.values.where((e) => e.value == json).firstOrNull;

String? _externalEnumToJson(OpenApiParameterLocation? status) => status?.value;
