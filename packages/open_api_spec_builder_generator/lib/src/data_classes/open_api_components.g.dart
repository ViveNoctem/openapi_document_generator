// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_components.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiComponents _$OpenApiComponentsFromJson(Map<String, dynamic> json) =>
    OpenApiComponents(
      schemas: (json['schemas'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          OpenApiSchemaContent.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );

Map<String, dynamic> _$OpenApiComponentsToJson(OpenApiComponents instance) =>
    <String, dynamic>{'schemas': ?instance.schemas};
