// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiParameter _$OpenApiParameterFromJson(Map<String, dynamic> json) =>
    OpenApiParameter(
      name: json['name'] as String?,
      location: _externalEnumFromJson(json['in'] as String?),
      description: json['description'] as String?,
      required: json['required'] as bool?,
      deprecated: json['deprecated'] as bool?,
      schema: const RawJsonStringConverter().fromJson(json['schema']),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$OpenApiParameterToJson(OpenApiParameter instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'in': ?_externalEnumToJson(instance.location),
      'description': ?instance.description,
      'required': ?instance.required,
      'deprecated': ?instance.deprecated,
      'schema': ?_$JsonConverterToJson<dynamic, String>(
        instance.schema,
        const RawJsonStringConverter().toJson,
      ),
      'content': ?instance.content,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
