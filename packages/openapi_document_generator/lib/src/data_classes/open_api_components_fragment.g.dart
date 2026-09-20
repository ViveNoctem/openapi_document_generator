// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_components_fragment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiComponentsFragment _$OpenApiComponentsFragmentFromJson(
  Map<String, dynamic> json,
) => OpenApiComponentsFragment(
  schemas: (json['schemas'] as List<dynamic>)
      .map(
        (e) => _$recordConvert(
          e,
          ($jsonValue) => (
            className: $jsonValue['className'] as String,
            uri: $jsonValue['uri'] as String,
          ),
        ),
      )
      .toSet(),
);

Map<String, dynamic> _$OpenApiComponentsFragmentToJson(
  OpenApiComponentsFragment instance,
) => <String, dynamic>{
  'schemas': instance.schemas
      .map((e) => <String, dynamic>{'className': e.className, 'uri': e.uri})
      .toList(),
};

$Rec _$recordConvert<$Rec>(Object? value, $Rec Function(Map) convert) =>
    convert(value as Map<String, dynamic>);
