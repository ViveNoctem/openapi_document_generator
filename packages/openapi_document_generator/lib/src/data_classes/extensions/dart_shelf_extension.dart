// TODO RecursiveAstVisitor2 is experimental, but RecursiveAstVisitor is annotated with WillBeDeprecated
// ignore_for_file: experimental_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:openapi_document_generator/src/data_classes/extensions/i_builder_extension.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_parameter.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_partial_result.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_path_item.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:openapi_document_generator/src/utils/annotation_reader.dart';
import 'package:openapi_document_generator/src/utils/content.utils.dart';
import 'package:openapi_document_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

class const DartShelfExtension({
  final TypeCheckers typeCheckers = const TypeCheckers(),
  final AnnotationReader annotationReader = const AnnotationReader(),
  final ContentUtils contentUtil = const ContentUtils(),
}) implements IBuilderExtension {
  @override
  Future<ResultOf<OpenApiFragment, String>> getExtensionFragment({
    required Map<
      ClassElement?,
      (List<OpenapiEndpointElement>, InternOpenapiController?)
    >
    controllerEndpointMap,
    required Map<OpenapiEndpointElement, OpenapiPartialResult> partialResult,
    required BuildStep buildStep,
  }) async {
    // TODO PLAN
    // TODO iterate through map
    // TODO check if router is given
    // TODO evaluate router. maybe get methods and paths
    // TODO check if a method in List<OpenapiEndpointElement> is used in router
    // TODO evaluate method itself. Parameters, but remove request object etc.

    OpenApiPaths paths = {};
    OpenApiComponentsFragment components = OpenApiComponentsFragment(
      schemas: {},
    );

    final routeChecker = typeCheckers.getDartShelfRoute();

    for (final MapEntry(
          key: controllerClass,
          value: (endpointElements, controllerAnnotation),
        )
        in controllerEndpointMap.entries) {
      final routerRoutes = await _findShelfRouter(
        controllerClass,
        controllerAnnotation?.shelfRouter,
        buildStep,
      );

      // TODO merge rank
      // TODO 1. Annotation doesn't matter, fragment builder handles that
      // TODO 2. Route method Annotation from generator
      // TODO 3. analyzed router element

      for (final endpoint in endpointElements) {
        final annotation = endpoint.element.annotation;
        final element = endpoint.element.element;
        final routeAnnotations = routeChecker.annotationsOf(element);

        final endPointRoutes = <(String, HttpMethod)>[];

        final readAnnotations = routeAnnotations
            .map(
              (s) => annotationReader.readRouteAnnotation(ConstantReader((s))),
            )
            .nonNulls
            .toList();

        if (readAnnotations.isNotEmpty) {
          for (final readAnnotation in readAnnotations) {
            final httpMethod = HttpMethod.fromString(readAnnotation.verb);
            if (httpMethod == null) {
              continue;
            }

            endPointRoutes.add((readAnnotation.route, httpMethod));
          }
        }

        // TODO only use router routes if no annotations are found
        // TODO if the user did annotations he probably uses the generator. We trust the User not the router analysis
        // TODO
        if (readAnnotations.isEmpty && routerRoutes != null) {
          for (final routerRoute in routerRoutes) {
            if (routerRoute.$3 != element) {
              continue;
            }

            endPointRoutes.add((routerRoute.$1, routerRoute.$2));
          }
        }

        // TODO if routes are still empty use partialResult?

        // TODO analyze return values parameters.
        // TODO responses probably not possible
        final parameterResult = _readShelfParameter(element);
        for (final (path, method) in endPointRoutes) {
          final pathItem = paths.putIfAbsent(
            path,
            () => InternOpenapiPathItem(),
          );

          final operation = InternOpenApiOperation(
            parameters: parameterResult?.$1,
          );

          final inferred = InternOpenapiPathItem.withMethod(method, operation);
          if (pathItem.canMerge(inferred) == false) {
            continue;
          }

          paths[path] = pathItem.merge(inferred);
          components.schemas.addAll(parameterResult?.$2 ?? []);
        }
      }
    }

    return SuccessOf(OpenApiFragment(paths: paths, components: components));
  }

  (List<InternOpenApiParameter>, Set<DartTypeJson>)? _readShelfParameter(
    Element element,
  ) {
    if (element is! FunctionTypedElement) {
      return null;
    }

    final openApiParameter = <InternOpenApiParameter>[];
    final components = <DartTypeJson>{};
    final requestChecker = typeCheckers.getDartShelfRequest();

    for (final parameter in element.formalParameters) {
      // Skip defualt request parameter
      if (requestChecker.isExactlyType(parameter.type)) {
        continue;
      }

      final parameterAnnotation = typeCheckers
          .getParameterChecker()
          .firstAnnotationOf(parameter, throwOnUnresolved: false);
      InternOpenApiParameter? annotationParameter = annotationReader
          .readOpenApiParameter(ConstantReader(parameterAnnotation));

      // only null if parameter is ignored
      if (annotationParameter == null) {
        continue;
      }

      final schema = contentUtil.getOpenApiSchemaForType(
        type: parameter.type,
        isComponents: false,
      );

      final inferredParameter = InternOpenApiParameter(
        name: parameter.displayName,
        location: .path,
        schema: schema.$1,
        required: parameter.isRequired,
      );

      final mergedParameter = annotationParameter.merge(inferredParameter);

      components.addAll(
        contentUtil.readDartTypesFromContent(mergedParameter.schema),
      );
      openApiParameter.add(mergedParameter);
    }

    return (openApiParameter, components);
  }

  /// TODO Route.mount to define subroute if Controller Annotation doesn't have one
  Future<List<(String, HttpMethod, MethodElement)>?> _findShelfRouter(
    ClassElement? controllerClass,
    ConstantReader? shelfRouter,
    BuildStep buildStep,
  ) async {
    final annotationRouter = await _evaluateAnnotationShelfRouter(
      shelfRouter,
      buildStep,
    );

    if (annotationRouter != null && annotationRouter.isNotEmpty) {
      return annotationRouter;
    }

    if (controllerClass == null) {
      return null;
    }

    final fieldController = await _evaluateFieldShelfRouter(
      controllerClass.fields,
      buildStep,
    );

    if (fieldController != null) {
      return fieldController;
    }

    return null;
  }

  /// Checks whether the class has a Router router or Handler handler field/getter
  ///
  /// if one is found the Router router is analyzed and all paths returned
  Future<List<(String, HttpMethod, MethodElement)>?> _evaluateFieldShelfRouter(
    List<FieldElement> fields,
    BuildStep buildStep,
  ) async {
    final routerChecker = typeCheckers.getDartShelfRouter();
    Element? fieldOrGetter = null;

    for (final field in fields) {
      if (routerChecker.isExactlyType(field.type) && field.name == "router") {
      } else if (typeCheckers.isExactlyDartShelfHandler(field.type) &&
          field.name == "handler") {
      } else {
        continue;
      }

      if (field.getter case final getter? when field.isOriginGetterSetter) {
        fieldOrGetter = getter;
        break;
      } else if (field.isOriginDeclaration) {
        fieldOrGetter = field;
      }
    }

    if (fieldOrGetter == null) {
      return null;
    }

    final fieldFragment = fieldOrGetter.firstFragment;
    var parsedFieldOrGetter = await buildStep.resolver.astNodeFor(
      fieldFragment,
      resolve: true,
    );

    if (parsedFieldOrGetter == null) {
      return null;
    }

    if (parsedFieldOrGetter is VariableDeclaration) {
      final visitor = RouterVisitor();

      parsedFieldOrGetter.accept2(visitor);
      return visitor.result;
    } else if (parsedFieldOrGetter is MethodDeclaration) {
      final visitor = RouterVisitor();

      parsedFieldOrGetter.accept2(visitor);
      return visitor.result;
    }

    return null;
  }

  Future<List<(String, HttpMethod, MethodElement)>?>
  _evaluateAnnotationShelfRouter(
    ConstantReader? shelfRouter,
    BuildStep buildStep,
  ) async {
    if (shelfRouter == null || shelfRouter.isNull == true) {
      return null;
    }

    final typeValue = shelfRouter.objectValue.type;
    if (typeValue is FunctionType) {
      final functionType = shelfRouter.objectValue.toFunctionValue()!;

      // TODO search in method for all invocations of Router.add
      final library = functionType.firstFragment;
      final parsedNode = await buildStep.resolver.astNodeFor(
        library,
        resolve: true,
      );

      if (parsedNode is FunctionDeclaration) {
        final visitor = RouterVisitor();

        parsedNode.accept2(visitor);
        return visitor.result;
      }
      return null;
    } else {
      return null;
    }
  }
}

class RouterVisitor({final TypeCheckers typeCheckers = const TypeCheckers()})
    extends RecursiveAstVisitor2<void> {
  List<(String, HttpMethod, MethodElement)> result = [];

  // @override
  // (String, HttpMethod, MethodElement) visitVariableDeclaration(VariableDeclaration node) {
  //   if (node.declaredFragment?.element case final notNull?) {
  //     _trackedRouters.add(notNull);
  //   }
  //   return super.visitVariableDeclaration(node);
  // }

  // TODO check Router get router =>
  // TODO check late final Handler handler =

  bool _isRouterMethod(MethodInvocation method) {
    final routerElement = method.methodName.element?.enclosingElement;

    if (routerElement == null) {
      return false;
    }

    return typeCheckers.getDartShelfRouter().isExactly(routerElement);
  }

  (String, HttpMethod, MethodElement)? _readMethod(MethodInvocation method) {
    HttpMethod? httpMethod = switch (method.methodName.name) {
      'get' => .get,
      'post' => .post,
      'put' => .put,
      'delete' => .delete,
      'options' => .options,
      'head' => .head,
      'patch' => .patch,
      'trace' => .trace,
      'add' => null,
      _ => null,
    };

    if (httpMethod == null && method.methodName.name != 'add') {
      return null;
    }

    // every method except add has the same Options
    final int routeParameter;
    final int handlerParameter;
    final int? verbParameter;

    if (method.methodName.name == 'add') {
      if (method.argumentList.arguments2.length != 3) {
        return null;
      }
      verbParameter = 0;
      routeParameter = 1;
      handlerParameter = 2;
    } else {
      if (method.argumentList.arguments2.length != 2) {
        return null;
      }
      verbParameter = null;
      routeParameter = 0;
      handlerParameter = 1;
    }

    final String path;
    final MethodElement handler;

    final argument = method.argumentList.arguments2;

    if (verbParameter != null) {
      final verbArgument = argument[verbParameter];
      if (verbArgument is! SimpleStringLiteral) {
        return null;
      }

      httpMethod = HttpMethod.fromString(verbArgument.value);
    }

    if (httpMethod == null) {
      return null;
    }

    final routeArgument = argument[routeParameter];

    if (routeArgument is! SimpleStringLiteral) {
      return null;
    }

    path = routeArgument.value;

    final handlerArgument = argument[handlerParameter];

    final Element? element;
    if (handlerArgument is UnqualifiedNameExpression) {
      element = handlerArgument.resolution?.element;
    } else if (handlerArgument is Identifier) {
      element = handlerArgument.element;
    } else {
      return null;
    }

    if (element is MethodElement) {
      handler = element;
    } else {
      return null;
    }

    return (path, httpMethod, handler);
  }

  @override
  void visitCascadeExpression(CascadeExpression node) {
    // Iteriere durch alle Abschnitte der Kaskade (die ..write() Aufrufe)
    for (final section in node.cascadeSections) {
      if (section is MethodInvocation) {
        if (_isRouterMethod(section) == false) {
          continue;
        }

        final methodResult = _readMethod(section);
        if (methodResult != null) {
          result.add(methodResult);
        }
      }
    }

    return super.visitCascadeExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_isRouterMethod(node) == false) {
      return super.visitMethodInvocation(node);
    }

    final methodResult = _readMethod(node);
    if (methodResult != null) {
      result.add(methodResult);
    }

    return super.visitMethodInvocation(node);
  }
}
