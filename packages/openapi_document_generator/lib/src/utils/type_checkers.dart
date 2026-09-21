import 'package:openapi_document_annotation/openapi_document_annotation.dart'
    show OpenapiEndpoint, OpenapiController, OpenapiParameter;
import 'package:source_gen/source_gen.dart';

class const TypeCheckers() {
  final TypeChecker _openapiController = const TypeChecker.typeNamed(
    OpenapiController,
    inPackage: "openapi_document_annotation",
  );

  final TypeChecker _openapiEndpoint = const TypeChecker.typeNamed(
    OpenapiEndpoint,
    inPackage: "openapi_document_annotation",
  );

  final TypeChecker _openapiParameter = const TypeChecker.typeNamed(
    OpenapiParameter,
    inPackage: "openapi_document_annotation",
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
