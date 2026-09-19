import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';

part 'open_api_spec.g.dart';

/// Key is the path
/// value Map of HttpMethods and their corresponding Endpoint description
typedef OpenApiPaths = Map<String, Map<HttpMethod, OpenApiEndpoint>>;
typedef OpenApiPathEnty = MapEntry<String, Map<HttpMethod, OpenApiEndpoint>>;

@JsonSerializable()
final class OpenApiSpec({
  required final OpenApiInfo info,
  required final OpenApiPaths paths,
  required final EOpenapiVersion openapi,
}) {
  factory OpenApiSpec.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSpecFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiSpecToJson(this);
}

@JsonSerializable()
final class OpenApiInfo({
  required final String title,
  required final String version,
}) {
  factory OpenApiInfo.fromJson(Map<String, dynamic> json) =>
      _$OpenApiInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiInfoToJson(this);
}

@JsonEnum(valueField: "versionCode")
enum EOpenapiVersion {
  openApi300("3.0.0"),
  openApi310("3.1.0"),
  openApi320("3.2.0");

  final String versionCode;

  const EOpenapiVersion(this.versionCode);
}

@JsonEnum(valueField: "value")
enum const HttpMethod(final String value) {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  options('OPTIONS'),
  head('HEAD'),
  patch('PATCH'),
  trace('TRACE'),
  query('QUERY');

  static HttpMethod? fromString(String string) {
    for (final value in values) {
      if (value.value.toLowerCase() == string.toLowerCase()) return value;
    }
    return null;
  }
}
