// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternOpenApiParameter _$InternOpenApiParameterFromJson(
  Map<String, dynamic> json,
) => InternOpenApiParameter(
  name: json['name'] as String?,
  location: _externalEnumFromJson(json['in'] as String?),
  description: json['description'] as String?,
  required: json['required'] as bool?,
  deprecated: json['deprecated'] as bool?,
  schema: json['schema'] == null
      ? null
      : OpenApiSchemaContent.fromJson(json['schema'] as Map<String, dynamic>),
  content: json['content'] as String?,
);

Map<String, dynamic> _$InternOpenApiParameterToJson(
  InternOpenApiParameter instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'in': ?_externalEnumToJson(instance.location),
  'description': ?instance.description,
  'required': ?instance.required,
  'deprecated': ?instance.deprecated,
  'schema': ?instance.schema,
  'content': ?instance.content,
};
