// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi_path_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternOpenapiPathItem _$InternOpenapiPathItemFromJson(
  Map<String, dynamic> json,
) => InternOpenapiPathItem(
  ref: json[r'$ref'] as String?,
  summary: json['summary'] as String?,
  description: json['description'] as String?,
  get: json['get'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['get'] as Map<String, dynamic>),
  put: json['put'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['put'] as Map<String, dynamic>),
  post: json['post'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['post'] as Map<String, dynamic>),
  delete: json['delete'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['delete'] as Map<String, dynamic>),
  options: json['options'] == null
      ? null
      : InternOpenApiOperation.fromJson(
          json['options'] as Map<String, dynamic>,
        ),
  head: json['head'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['head'] as Map<String, dynamic>),
  patch: json['patch'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['patch'] as Map<String, dynamic>),
  trace: json['trace'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['trace'] as Map<String, dynamic>),
  query: json['query'] == null
      ? null
      : InternOpenApiOperation.fromJson(json['query'] as Map<String, dynamic>),
  parameters: (json['parameters'] as List<dynamic>?)
      ?.map((e) => InternOpenApiParameter.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InternOpenapiPathItemToJson(
  InternOpenapiPathItem instance,
) => <String, dynamic>{
  r'$ref': ?instance.ref,
  'summary': ?instance.summary,
  'description': ?instance.description,
  'get': ?instance.get,
  'put': ?instance.put,
  'post': ?instance.post,
  'delete': ?instance.delete,
  'options': ?instance.options,
  'head': ?instance.head,
  'patch': ?instance.patch,
  'trace': ?instance.trace,
  'query': ?instance.query,
  'parameters': ?instance.parameters,
};
