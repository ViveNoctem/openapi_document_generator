import 'package:analyzer/dart/element/type.dart';
import 'package:openapi_document_annotation/openapi_document_annotation.dart'
    show OpenapiEndpoint, OpenapiController, OpenapiParameter;
import 'package:source_gen/source_gen.dart';

class const TypeCheckers() {
  // region openapi
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

  // endregion

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

  // region dartShelf

  final TypeChecker _dartShelfRouter = const TypeChecker.fromUrl(
    "package:shelf_router/src/router.dart#Router",
  );

  final TypeChecker _dartShelfRequest = const TypeChecker.fromUrl(
    "package:shelf/src/request.dart#Request",
  );

  final TypeChecker _dartShelfResponse = const TypeChecker.fromUrl(
    "package:shelf/src/response.dart#Response",
  );

  final TypeChecker _dartShelfRoute = const TypeChecker.fromUrl(
    "package:shelf_router/src/route.dart#Route",
  );

  TypeChecker getDartShelfRoute() {
    return _dartShelfRoute;
  }

  TypeChecker getDartShelfResponse() {
    return _dartShelfResponse;
  }

  TypeChecker getDartShelfRouter() {
    return _dartShelfRouter;
  }

  TypeChecker getDartShelfRequest() {
    return _dartShelfRequest;
  }

  bool isExactlyDartShelfHandler(DartType type) {
    if (type is! FunctionType) {
      return false;
    }

    final returnType = type.returnType;
    final returnTypeName = returnType.element;
    final responseChecker = getDartShelfResponse();

    if (returnTypeName == null) {
      return false;
    }

    bool isValidReturn = false;

    if (responseChecker.isExactly(returnTypeName)) {
      isValidReturn = true;
    } else if (returnType.isDartAsyncFutureOr &&
        returnType is InterfaceType &&
        returnType.typeArguments.isNotEmpty) {
      final genericType = returnType.typeArguments.first;
      if (responseChecker.isExactlyType(genericType)) {
        isValidReturn = true;
      }
    }

    if (!isValidReturn) {
      return false;
    }

    if (type.normalParameterTypes.length != 1) {
      return false;
    }

    final firstParamElement = type.normalParameterTypes.first.element;
    if (firstParamElement == null) {
      return false;
    }

    if (getDartShelfRequest().isExactly(firstParamElement) == false) {
      return false;
    }

    return true;
  }

  // endregion
}
