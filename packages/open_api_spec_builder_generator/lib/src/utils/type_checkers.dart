import 'package:open_api_spec_builder/open_api_spec_builder.dart'
    show OpenapiEndpoint, AOpenapiController, OpenapiParameter;
import 'package:source_gen/source_gen.dart';

class const TypeCheckers() {
  final TypeChecker _openapiController = const TypeChecker.typeNamed(
    AOpenapiController,
    inPackage: "open_api_spec_builder",
  );

  final TypeChecker _openapiEndpoint = const TypeChecker.typeNamed(
    OpenapiEndpoint,
    inPackage: "open_api_spec_builder",
  );

  final TypeChecker _openapiParameter = const TypeChecker.typeNamed(
    OpenapiParameter,
    inPackage: "open_api_spec_builder",
  );

  TypeChecker getControllerTypeChecker() {
    return _openapiController;
  }

  TypeChecker getEndpointChecker() {
    return _openapiEndpoint;
  }

  TypeChecker getParameterChecker() {
    return _openapiParameter;
  }

  // region dartFrog

  final TypeChecker _dartFrogRequestContext =
      const TypeChecker.typeNamedLiterally(
        "RequestContext",
        inPackage: "dart_frog",
      );

  TypeChecker getDartFrogRequestContextChecker() {
    return _dartFrogRequestContext;
  }

  //endregion
}
