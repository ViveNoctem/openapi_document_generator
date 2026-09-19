// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiEndpoint _$OpenApiEndpointFromJson(Map<String, dynamic> json) =>
    OpenApiEndpoint(
      responses: (json['responses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          int.parse(k),
          OpenApiResponse.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );

Map<String, dynamic> _$OpenApiEndpointToJson(OpenApiEndpoint instance) =>
    <String, dynamic>{
      'responses': instance.responses.map((k, e) => MapEntry(k.toString(), e)),
    };

OpenApiResponse _$OpenApiResponseFromJson(Map<String, dynamic> json) =>
    OpenApiResponse(description: json['description'] as String);

Map<String, dynamic> _$OpenApiResponseToJson(OpenApiResponse instance) =>
    <String, dynamic>{'description': instance.description};
