import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

part 'open_api_document.g.dart';

/// Key is the path
/// value Map of HttpMethods and their corresponding Endpoint description
/// TODO Map<httpMethod, InternOpenApiEndpoint is wrong it should be a separate  PathItemObject
/// TODO see https://spec.openapis.org/oas/v3.2.0.html#path-item-object;
typedef OpenApiPaths = Map<String, Map<HttpMethod, InternOpenApiOperation>>;
typedef OpenApiPathEntry = (String, HttpMethod, InternOpenApiOperation);
typedef DartTypeJson = ({String uri, String className});

@JsonSerializable()
final class const OpenapiDocument({
  final EOpenapiVersion? openapi,
  final OpenapiInfo? info,
  final OpenApiPaths? paths,
  final OpenApiComponents? components,
}) implements IDocumentNode {
  factory OpenapiDocument.fromJson(Map<String, dynamic> json) =>
      _$OpenapiDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenapiDocumentToJson(this);

  @override
  IDocumentNode merge(IDocumentNode other) {
    if (other is! OpenapiDocument) {
      return this;
    }
    return OpenapiDocument(
      paths: paths ?? other.paths,
      info: info ?? other.info,
      openapi: openapi ?? other.openapi,
      components: components ?? other.components,
    );
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/openapi.json";
    var errors = ValidationErrors([]);

    if (openapi == null) {
      errors.validations.add(
        ValidationEntry.isRequired(path: path, fieldName: 'openapi'),
      );
    }

    if (info == null) {
      errors.validations.add(
        ValidationEntry.isRequired(path: path, fieldName: 'info'),
      );
    } else {
      final infoValidation = info?.validate(path);
      if (infoValidation case FailureOf<void, ValidationErrors>()) {
        errors = errors.merge(infoValidation.failure);
      }
    }

    if (paths case final safePaths?) {
      for (final MapEntry(:key, :value) in safePaths.entries) {
        String localPath;
        if (key == "/") {
          localPath = path + "/paths/";
        } else if (key.startsWith("/") == false) {
          localPath = path + "/paths/" + key + "/";
        } else {
          localPath = path + "/paths" + key + "/";
        }

        if (key.startsWith("/") == false) {
          errors.validations.add(
            ValidationEntry(
              path: localPath,
              error: "All paths MUST start with a forward slash",
              type: .malformedField,
            ),
          );
        }

        for (final MapEntry(key: method, value: endpoint) in value.entries) {
          localPath = localPath + method.value;

          final endpointValidation = endpoint.validate(localPath);

          if (endpointValidation case FailureOf<void, ValidationErrors>()) {
            errors = errors.merge(endpointValidation.failure);
          }
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
final class const OpenapiInfo({final String? title, final String? version})
    implements IDocumentNode {
  factory OpenapiInfo.fromJson(Map<String, dynamic> json) =>
      _$OpenapiInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenapiInfoToJson(this);

  @override
  IDocumentNode merge(IDocumentNode other) {
    throw UnimplementedError("Not supportet for OpenApiInfo");
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/info";

    final validationErrors = <ValidationEntry>[];

    if (title == null || title?.isEmpty == true) {
      validationErrors.add(
        ValidationEntry.isRequired(path: path, fieldName: "title"),
      );
    }

    if (version == null || version?.isEmpty == true) {
      validationErrors.add(
        ValidationEntry.isRequired(path: path, fieldName: "version"),
      );
    }

    if (validationErrors.isNotEmpty) {
      return FailureOf(ValidationErrors(validationErrors));
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

  static EOpenapiVersion fromString(String value) {
    return values.firstWhere(
      (s) => s.versionCode == value,
      orElse: () => openApi310,
    );
  }

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
