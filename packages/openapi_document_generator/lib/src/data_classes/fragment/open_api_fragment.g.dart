// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_fragment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiFragment _$OpenApiFragmentFromJson(Map<String, dynamic> json) =>
    OpenApiFragment(
      paths: (json['paths'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          InternOpenapiPathItem.fromJson(e as Map<String, dynamic>),
        ),
      ),
      components: OpenApiComponentsFragment.fromJson(
        json['components'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OpenApiFragmentToJson(OpenApiFragment instance) =>
    <String, dynamic>{
      'paths': instance.paths,
      'components': instance.components,
    };
