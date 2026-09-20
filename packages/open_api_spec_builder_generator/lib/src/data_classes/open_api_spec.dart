import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_components.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

part 'open_api_spec.g.dart';

/// Key is the path
/// value Map of HttpMethods and their corresponding Endpoint description
typedef OpenApiPaths = Map<String, Map<HttpMethod, InternOpenApiEndpoint>>;
typedef OpenApiPathEntry = (String, HttpMethod, InternOpenApiEndpoint);
typedef DartTypeJson = ({String uri, String className});

@JsonSerializable()
final class OpenApiSpec({
  required final EOpenapiVersion openapi,
  required final OpenApiInfo info,
  required final OpenApiPaths paths,
  required final OpenApiComponents components,
}) implements ISpecNode {
  factory OpenApiSpec.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSpecFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiSpecToJson(this);

  @override
  ISpecNode merge(ISpecNode other) {
    throw UnimplementedError("Not supported for OpenApiSpec");
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/openapi.json";
    var errors = ValidationErrors([]);
    final infoValidation = info.validate(path);
    if (infoValidation case FailureOf<void, ValidationErrors>()) {
      errors = errors.merge(infoValidation.failure);
    }

    for (final MapEntry(:key, :value) in paths.entries) {
      for (final MapEntry(key: method, value: endpoint) in value.entries) {
        final String localPath;
        if (key == "/") {
          localPath = path + "/path/" + method.value;
        } else {
          localPath = path + "/path" + key + "/" + method.value;
        }

        final endpointValidation = endpoint.validate(localPath);

        if (endpointValidation case FailureOf<void, ValidationErrors>()) {
          errors = errors.merge(endpointValidation.failure);
        }
      }
    }

    if (errors.validations.isNotEmpty) {
      return FailureOf(errors);
    }

    return SuccessOf(null);
  }
}

@JsonSerializable()
final class OpenApiInfo({
  required final String title,
  required final String version,
}) implements ISpecNode {
  factory OpenApiInfo.fromJson(Map<String, dynamic> json) =>
      _$OpenApiInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiInfoToJson(this);

  @override
  ISpecNode merge(ISpecNode other) {
    throw UnimplementedError("Not supportet for OpenApiInfo");
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/info";
    if (title.isEmpty) {
      return FailureOf(
        ValidationErrors([
          ValidationEntry(path: path, error: "title is required"),
        ]),
      );
    }

    if (version.isEmpty) {
      return FailureOf(
        ValidationErrors([
          ValidationEntry(path: path, error: "version is required"),
        ]),
      );
    }

    return SuccessOf(null);
  }
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
  get('get'),
  post('post'),
  put('put'),
  delete('delete'),
  options('options'),
  head('head'),
  patch('patch'),
  trace('trace'),
  query('query');

  static HttpMethod? fromString(String string) {
    for (final value in values) {
      if (value.value.toLowerCase() == string.toLowerCase()) return value;
    }
    return null;
  }
}
