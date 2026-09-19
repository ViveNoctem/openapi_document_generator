// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_builder_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiBuilderOptions _$OpenApiBuilderOptionsFromJson(
  Map<String, dynamic> json,
) => OpenApiBuilderOptions(
  apiLibrary:
      $enumDecodeNullable(_$EApiLibraryEnumMap, json['apiLibrary']) ?? .none,
);

Map<String, dynamic> _$OpenApiBuilderOptionsToJson(
  OpenApiBuilderOptions instance,
) => <String, dynamic>{
  'apiLibrary': _$EApiLibraryEnumMap[instance.apiLibrary]!,
};

const _$EApiLibraryEnumMap = {
  EApiLibrary.none: 'none',
  EApiLibrary.shelf: 'shelf',
  EApiLibrary.dartFrog: 'dartFrog',
  EApiLibrary.serverPod: 'serverPod',
};
