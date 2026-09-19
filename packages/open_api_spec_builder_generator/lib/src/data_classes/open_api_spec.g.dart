// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiSpec _$OpenApiSpecFromJson(Map<String, dynamic> json) => OpenApiSpec(
  info: OpenApiInfo.fromJson(json['info'] as Map<String, dynamic>),
  paths: (json['paths'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$HttpMethodEnumMap, k),
          OpenApiEndpoint.fromJson(e as Map<String, dynamic>),
        ),
      ),
    ),
  ),
  openapi: $enumDecode(_$EOpenapiVersionEnumMap, json['openapi']),
);

Map<String, dynamic> _$OpenApiSpecToJson(OpenApiSpec instance) =>
    <String, dynamic>{
      'info': instance.info,
      'paths': instance.paths.map(
        (k, e) =>
            MapEntry(k, e.map((k, e) => MapEntry(_$HttpMethodEnumMap[k]!, e))),
      ),
      'openapi': _$EOpenapiVersionEnumMap[instance.openapi]!,
    };

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.options: 'OPTIONS',
  HttpMethod.head: 'HEAD',
  HttpMethod.patch: 'PATCH',
  HttpMethod.trace: 'TRACE',
  HttpMethod.query: 'QUERY',
};

const _$EOpenapiVersionEnumMap = {
  EOpenapiVersion.openApi300: '3.0.0',
  EOpenapiVersion.openApi310: '3.1.0',
  EOpenapiVersion.openApi320: '3.2.0',
};

OpenApiInfo _$OpenApiInfoFromJson(Map<String, dynamic> json) => OpenApiInfo(
  title: json['title'] as String,
  version: json['version'] as String,
);

Map<String, dynamic> _$OpenApiInfoToJson(OpenApiInfo instance) =>
    <String, dynamic>{'title': instance.title, 'version': instance.version};
