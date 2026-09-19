// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiSpec _$OpenApiSpecFromJson(Map<String, dynamic> json) => OpenApiSpec(
  openapi: $enumDecode(_$EOpenapiVersionEnumMap, json['openapi']),
  info: OpenApiInfo.fromJson(json['info'] as Map<String, dynamic>),
  paths: (json['paths'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$HttpMethodEnumMap, k),
          InternOpenApiEndpoint.fromJson(e as Map<String, dynamic>),
        ),
      ),
    ),
  ),
  components: OpenApiComponents.fromJson(
    json['components'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OpenApiSpecToJson(OpenApiSpec instance) =>
    <String, dynamic>{
      'openapi': _$EOpenapiVersionEnumMap[instance.openapi]!,
      'info': instance.info,
      'paths': instance.paths.map(
        (k, e) =>
            MapEntry(k, e.map((k, e) => MapEntry(_$HttpMethodEnumMap[k]!, e))),
      ),
      'components': instance.components,
    };

const _$EOpenapiVersionEnumMap = {
  EOpenapiVersion.openApi300: '3.0.0',
  EOpenapiVersion.openApi310: '3.1.0',
  EOpenapiVersion.openApi320: '3.2.0',
};

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'get',
  HttpMethod.post: 'post',
  HttpMethod.put: 'put',
  HttpMethod.delete: 'delete',
  HttpMethod.options: 'options',
  HttpMethod.head: 'head',
  HttpMethod.patch: 'patch',
  HttpMethod.trace: 'trace',
  HttpMethod.query: 'query',
};

OpenApiInfo _$OpenApiInfoFromJson(Map<String, dynamic> json) => OpenApiInfo(
  title: json['title'] as String,
  version: json['version'] as String,
);

Map<String, dynamic> _$OpenApiInfoToJson(OpenApiInfo instance) =>
    <String, dynamic>{'title': instance.title, 'version': instance.version};
