// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiSchemaContent _$OpenApiSchemaContentFromJson(
  Map<String, dynamic> json,
) => OpenApiSchemaContent(
  type: $enumDecodeNullable(_$OpenApiSchemaTypeEnumMap, json['type']),
  ref: json[r'$ref'] as String?,
  required: (json['required'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  format: json['format'] as String?,
  properties: (json['properties'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, OpenApiSchemaContent.fromJson(e as Map<String, dynamic>)),
  ),
  enumVal: (json['enum'] as List<dynamic>?)?.map((e) => e as String).toList(),
  example: json['example'],
);

Map<String, dynamic> _$OpenApiSchemaContentToJson(
  OpenApiSchemaContent instance,
) => <String, dynamic>{
  'type': ?_$OpenApiSchemaTypeEnumMap[instance.type],
  r'$ref': ?instance.ref,
  'required': ?instance.required,
  'format': ?instance.format,
  'properties': ?instance.properties,
  'enum': ?instance.enumVal,
  'example': ?instance.example,
};

const _$OpenApiSchemaTypeEnumMap = {
  OpenApiSchemaType.object: 'object',
  OpenApiSchemaType.integer: 'integer',
  OpenApiSchemaType.string: 'string',
  OpenApiSchemaType.number: 'number',
  OpenApiSchemaType.nullVal: 'null',
  OpenApiSchemaType.boolean: 'boolean',
  OpenApiSchemaType.array: 'array',
};

OpenApiContent _$OpenApiContentFromJson(Map<String, dynamic> json) =>
    OpenApiContent(
      OpenApiSchemaContent.fromJson(json['schema'] as Map<String, dynamic>),
      json['example'],
    );

Map<String, dynamic> _$OpenApiContentToJson(OpenApiContent instance) =>
    <String, dynamic>{'schema': instance.schema, 'example': ?instance.example};
