// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternOpenApiOperation _$InternOpenApiOperationFromJson(
  Map<String, dynamic> json,
) => InternOpenApiOperation(
  responses: (json['responses'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      int.parse(k),
      InternOpenApiResponse.fromJson(e as Map<String, dynamic>),
    ),
  ),
  parameters: (json['parameters'] as List<dynamic>?)
      ?.map((e) => InternOpenApiParameter.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InternOpenApiOperationToJson(
  InternOpenApiOperation instance,
) => <String, dynamic>{
  'responses': ?instance.responses?.map((k, e) => MapEntry(k.toString(), e)),
  'parameters': ?instance.parameters,
};

InternOpenApiResponse _$InternOpenApiResponseFromJson(
  Map<String, dynamic> json,
) => InternOpenApiResponse(
  description: json['description'] as String?,
  content: (json['content'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, OpenapiMediaType.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$InternOpenApiResponseToJson(
  InternOpenApiResponse instance,
) => <String, dynamic>{
  'description': ?instance.description,
  'content': ?instance.content,
};
