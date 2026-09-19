import 'package:open_api_spec_builder/open_api_spec_builder.dart'
    show AOpenapiEndpoint, AOpenapiController;
import 'package:source_gen/source_gen.dart';

class const TypeCheckers() {
  final TypeChecker _openapiController = const TypeChecker.typeNamed(
    AOpenapiController,
    inPackage: "open_api_spec_builder",
  );

  final TypeChecker _openapiEndpoint = const TypeChecker.typeNamed(
    AOpenapiEndpoint,
    inPackage: "open_api_spec_builder",
  );

  TypeChecker getControllerTypeChecker() {
    return _openapiController;
  }

  TypeChecker getEndpointChecker() {
    return _openapiEndpoint;
  }
}
