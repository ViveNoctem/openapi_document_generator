import 'package:json_annotation/json_annotation.dart';

part 'open_api_endpoint.g.dart';

// TODO This class should probably not have the path und httpMethod
@JsonSerializable()
final class const OpenApiEndpoint({
  required final Map<int, OpenApiResponse> responses,
}) {
  factory OpenApiEndpoint.fromJson(Map<String, dynamic> json) =>
      _$OpenApiEndpointFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiEndpointToJson(this);
}

@JsonSerializable()
final class const OpenApiResponse({required final String description}) {
  factory OpenApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiResponseToJson(this);
}
