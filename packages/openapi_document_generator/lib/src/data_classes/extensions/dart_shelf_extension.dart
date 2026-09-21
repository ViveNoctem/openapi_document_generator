// TODO RecursiveAstVisitor2 is experimental, but RecursiveAstVisitor is annotated with WillBeDeprecated
// ignore_for_file: experimental_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:openapi_document_generator/src/data_classes/extensions/i_builder_extension.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_partial_result.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:openapi_document_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

class const DartShelfExtension({
  final TypeCheckers typeCheckers = const TypeCheckers(),
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

    for (final MapEntry(
          key: controllerClass,
          value: (endpointElements, controllerAnnotation),
        )
        in controllerEndpointMap.entries) {
      final result = await _evaluateShelfRouter(
        controllerAnnotation?.shelfRouter,
        buildStep,
      );

      for (final endpoint in endpointElements) {
        if (result?.map((s) => s.$3).contains(endpoint.element.element) ==
            true) {
          print("FOUND THE THING");
        }
      }
    }

    // TODO: implement getExtensionFragment
    throw UnimplementedError();
  }

  Future<List<(String, HttpMethod, MethodElement)>?> _evaluateShelfRouter(
    ConstantReader? shelfRouter,
    BuildStep buildStep,
  ) async {
    if (shelfRouter == null || shelfRouter.isNull == true) {
      return null;
    }

    final typeValue = shelfRouter.objectValue.type;

    /*    if (typeValue?.element case VariableElement a) {
      final b = a.constantInitializer2?.accept2(RouterVisitor());
      // TODO
    } else */
    if (typeValue case FunctionType b) {
      final functionType = shelfRouter.objectValue.toFunctionValue()!;

      // TODO search in method for all invocations of Router.add
      final library = functionType.firstFragment;
      final parsedNode = await buildStep.resolver.astNodeFor(
        library,
        resolve: true,
      );

      if (parsedNode case FunctionDeclaration a) {
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

  @override
  void visitCascadeExpression(CascadeExpression node) {
    // Iteriere durch alle Abschnitte der Kaskade (die ..write() Aufrufe)
    for (final section in node.cascadeSections) {
      if (section is MethodInvocation) {
        if (section.methodName.element?.enclosingElement
            case final routerElement?) {
          if (typeCheckers.getDartShelfRouter().isExactly(routerElement)) {
            print("found shelf router");
          }
        } else {
          continue;
        }

        if (section.methodName.name != 'get') {
          continue;
        }

        final arguments = section.argumentList.arguments2;

        if (arguments.length != 2) {
          continue;
        }

        final routeString = arguments.elementAt(0);
        final handler = arguments.elementAt(1);

        if (routeString is! SimpleStringLiteral) {
          //TODO only String literal supported for now
          continue;
        }

        if (handler is! Identifier) {
          // TODO only Identifier/PrefixedIdentifier supported now
          continue;
        }

        if (handler.element case MethodElement methodElement) {
          // TODO this is the Handler Method, that should be Annotated;
          result.add((routeString.value, .get, methodElement));
        }
      }
    }

    return super.visitCascadeExpression(node);
  }
}
