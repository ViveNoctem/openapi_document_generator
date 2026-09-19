// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_components.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiComponents _$OpenApiComponentsFromJson(Map<String, dynamic> json) =>
    OpenApiComponents(
      schemas: const RawJsonStringConverter().fromJson(json['schemas']),
    );

Map<String, dynamic> _$OpenApiComponentsToJson(OpenApiComponents instance) =>
    <String, dynamic>{
      'schemas': ?const RawJsonStringConverter().toJson(instance.schemas),
    };
