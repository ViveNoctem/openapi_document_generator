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
  schemaImportUri: _$recordConvertNullable(
    json['schemaImportUri'],
    ($jsonValue) => ($jsonValue[r'$1'] as String, $jsonValue[r'$2'] as String),
  ),
  schema: const RawJsonStringConverter().fromJson(json['schema']),
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
  'schemaImportUri': ?instance.schemaImportUri == null
      ? null
      : <String, dynamic>{
          r'$1': instance.schemaImportUri!.$1,
          r'$2': instance.schemaImportUri!.$2,
        },
  'schema': ?const RawJsonStringConverter().toJson(instance.schema),
  'content': ?instance.content,
};

$Rec? _$recordConvertNullable<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) => value == null ? null : convert(value as Map<String, dynamic>);
