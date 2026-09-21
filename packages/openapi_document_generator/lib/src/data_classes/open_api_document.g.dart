// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenapiDocument _$OpenapiDocumentFromJson(
  Map<String, dynamic> json,
) => OpenapiDocument(
  openapi: $enumDecodeNullable(_$EOpenapiVersionEnumMap, json['openapi']),
  info: json['info'] == null
      ? null
      : OpenapiInfo.fromJson(json['info'] as Map<String, dynamic>),
  paths: (json['paths'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, InternOpenapiPathItem.fromJson(e as Map<String, dynamic>)),
  ),
  components: json['components'] == null
      ? null
      : OpenApiComponents.fromJson(json['components'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OpenapiDocumentToJson(OpenapiDocument instance) =>
    <String, dynamic>{
      'openapi': ?_$EOpenapiVersionEnumMap[instance.openapi],
      'info': ?instance.info,
      'paths': ?instance.paths,
      'components': ?instance.components,
    };

const _$EOpenapiVersionEnumMap = {
  EOpenapiVersion.openApi300: '3.0.0',
  EOpenapiVersion.openApi310: '3.1.0',
  EOpenapiVersion.openApi320: '3.2.0',
};

OpenapiInfo _$OpenapiInfoFromJson(Map<String, dynamic> json) => OpenapiInfo(
  title: json['title'] as String?,
  version: json['version'] as String?,
);

Map<String, dynamic> _$OpenapiInfoToJson(OpenapiInfo instance) =>
    <String, dynamic>{'title': ?instance.title, 'version': ?instance.version};
