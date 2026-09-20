// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternOpenApiEndpoint _$InternOpenApiEndpointFromJson(
  Map<String, dynamic> json,
) => InternOpenApiEndpoint(
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

Map<String, dynamic> _$InternOpenApiEndpointToJson(
  InternOpenApiEndpoint instance,
) => <String, dynamic>{
  'responses': ?instance.responses?.map((k, e) => MapEntry(k.toString(), e)),
  'parameters': ?instance.parameters,
};

InternOpenApiResponse _$InternOpenApiResponseFromJson(
  Map<String, dynamic> json,
) => InternOpenApiResponse(
  description: json['description'] as String?,
  schema: json['schema'] == null
      ? null
      : OpenApiSchemaContent.fromJson(json['schema'] as Map<String, dynamic>),
  content: (json['content'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, OpenApiContent.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$InternOpenApiResponseToJson(
  InternOpenApiResponse instance,
) => <String, dynamic>{
  'description': ?instance.description,
  'schema': ?instance.schema,
  'content': ?instance.content,
};
