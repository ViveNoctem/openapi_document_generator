import 'package:openapi_document_generator/src/data_classes/open_api_builder_options.dart';
import 'package:pub_semver/pub_semver.dart';

class const OpenApiFragmentContext({
  required final OpenApiBuilderOptions options,
}) {}

BuilderContext builderContext = BuilderContext();

class BuilderContext({
  final String openApiVersionString = "3.0.0",
  final EApiLibrary apiLibrary = .none,
}) {
  late OpenApiVersion openapiVersion = _initopenApiVersion();

  OpenApiVersion _initopenApiVersion() {
    try {
      return OpenApiVersion(Version.parse(openApiVersionString));
    } catch (e) {
      return OpenApiVersion(Version(3, 1, 0));
    }
  }
}

extension type OpenApiVersion(Version version) implements Version;
