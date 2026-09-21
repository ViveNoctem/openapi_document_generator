import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:openapi_document_generator/src/data_classes/extensions/dart_shelf_extension.dart';
import 'package:openapi_document_generator/src/data_classes/extensions/i_builder_extension.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_builder_options.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_partial_result.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_path_item.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:openapi_document_generator/src/utils/annotation_reader.dart';
import 'package:openapi_document_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation_analyzer.dart';

class OpenApiFragmentBuilder implements Builder {
  final BuilderOptions options;
  final TypeCheckers typeCheckers;
  final AnnotationAnalyzer annotationAnalyzer;
  late final OpenApiBuilderOptions builderOptions;
  final AnnotationReader annotationReader;

  OpenApiFragmentBuilder({
    required this.options,
    this.typeCheckers = const TypeCheckers(),
    this.annotationAnalyzer = const AnnotationAnalyzer(),
    this.annotationReader = const AnnotationReader(),
  }) {
    builderOptions = OpenApiBuilderOptions.fromJson(options.config);
    builderContext = BuilderContext(apiLibrary: builderOptions.apiLibrary);
  }

  @override
  final buildExtensions = const {
    '.dart': ['.tmp.openapi.json'],
  };

  // TODO Iterate through all methods annotated with @OpenapiEndpoint
  // TODO check the containing class for @Openapicontroller to set default values
  // TODO this should be flexible enough for different kind of dart server frameworks
  // TODO shelf, dart_frog, alfred, Serverpod

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;

    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final reader = LibraryReader(library);

    final endPointChecker = typeCheckers.getEndpointChecker();
    final annotatedElements = reader.annotatedWith(endPointChecker).toList();
    final context = OpenApiFragmentContext(options: builderOptions);

    // TODO should maybe use a element Visitor to also find local Method declarations?
    final allClasses = library.children.whereType<ClassElement>();

    for (final classElement in allClasses) {
      for (final methodElement in classElement.methods) {
        final firstAnnotation = endPointChecker.firstAnnotationOfExact(
          methodElement,
        );
        if (firstAnnotation == null) {
          continue;
        }

        annotatedElements.add(
          AnnotatedElement(ConstantReader(firstAnnotation), methodElement),
        );
      }
    }

    if (annotatedElements.isEmpty) return;

    final allTypes = _getPreparedAnnotatedClasses(annotatedElements);

    // TODO this should be split into
    // TODO Run 1 of get OpenApiDocument from Annotation
    // TODO Run 2 of get OpenApiDocument from Extension builder
    // TODO Run 3 of get OpenApiDocument from Method/Class Element
    // TODO then merge all 3
    // TODO Annotation always wins, then specific extension, then general Method/Class

    // TODO Problems of this approach?
    // TODO Something can only be inferred because of other methods work
    // TODO In Annotation path for specific endpoint is set
    // TODO Extension builder can't infer path but responses and parameters
    // TODO how got merge both

    // TODO solution?
    // TODO Map<AnnotatedElement/Element, OpenApiPathEntry> to get everything found so far?

    final (annotationFragment, annotationPartialResult) = _doAnnotationRun(
      allTypes,
      context,
    );

    final extensionFragment = await _doExtensionRun(
      allTypes,
      context,
      annotationPartialResult,
      buildStep,
    );

    if (annotationFragment.paths.isEmpty) return;

    final result = annotationFragment;

    final outputId = buildStep.inputId.changeExtension('.tmp.openapi.json');
    await buildStep.writeAsString(outputId, jsonEncode(result));
  }

  Map<ClassElement?, (List<OpenapiEndpointElement>, InternOpenapiController?)>
  _getPreparedAnnotatedClasses(Iterable<AnnotatedElement> annotatedElements) {
    final controllerChecker = typeCheckers.getControllerTypeChecker();
    final allTypes =
        <
          ClassElement?,
          (List<OpenapiEndpointElement>, InternOpenapiController?)
        >{};

    for (final annotatedElement in annotatedElements) {
      final enclosingElement = annotatedElement.element.enclosingElement;

      final ClassElement? currentClass;
      final InternOpenapiController? currentClassAnnotation;
      if (enclosingElement is ClassElement) {
        currentClass = enclosingElement;
        final controllerAnnotation = controllerChecker.firstAnnotationOfExact(
          currentClass,
          throwOnUnresolved: false,
        );

        if (controllerAnnotation != null) {
          final openApiController = annotationReader.readOpenApiController(
            ConstantReader(controllerAnnotation),
          );
          currentClassAnnotation = openApiController;
        } else {
          currentClassAnnotation = null;
        }
      } else {
        currentClass = null;
        currentClassAnnotation = null;
      }

      if (annotatedElement.element is! MethodElement &&
          annotatedElement.element is! TopLevelFunctionElement) {
        continue;
      }

      final classEndpoint = allTypes.putIfAbsent(
        currentClass,
        () => ([], currentClassAnnotation),
      );
      classEndpoint.$1.add(OpenapiEndpointElement(annotatedElement));
    }

    return allTypes;
  }

  Future<OpenApiFragment> _doExtensionRun(
    Map<ClassElement?, (List<OpenapiEndpointElement>, InternOpenapiController?)>
    allTypes,
    OpenApiFragmentContext context,
    Map<OpenapiEndpointElement, OpenapiPartialResult> partialResult,
    BuildStep buildStep,
  ) async {
    final result = switch (context.options.apiLibrary) {
      EApiLibrary.none => throw UnimplementedError(),
      EApiLibrary.shelf => await (DartShelfExtension().getExtensionFragment(
        controllerEndpointMap: allTypes,
        partialResult: partialResult,
        buildStep: buildStep,
      )),
      EApiLibrary.dartFrog => throw UnimplementedError(),
      EApiLibrary.serverPod => throw UnimplementedError(),
    };

    switch (result) {
      case FailureOf<OpenApiFragment, String>():
        // TODO: Handle this case.
        throw UnimplementedError();
      case SuccessOf<OpenApiFragment, String>():
        return result.data;
    }
  }

  (OpenApiFragment, Map<OpenapiEndpointElement, OpenapiPartialResult>)
  _doAnnotationRun(
    Map<ClassElement?, (List<OpenapiEndpointElement>, InternOpenapiController?)>
    allTypes,
    OpenApiFragmentContext context,
  ) {
    final annotationFragment = OpenApiFragment(
      paths: {},
      components: OpenApiComponentsFragment(schemas: {}),
    );

    final partialResult = <OpenapiEndpointElement, OpenapiPartialResult>{};

    for (final MapEntry(
          key: classElement,
          value: (endpoints, controllerAnnotation),
        )
        in allTypes.entries) {
      for (final endpoint in endpoints) {
        final fragmentPart = annotationAnalyzer.readEndpointMethod(
          element: endpoint,
          context: context,
        );

        switch (fragmentPart) {
          case FailureOf<(OpenApiPathEntry, Set<DartTypeJson>), void>():
            continue;
          case SuccessOf<(OpenApiPathEntry, Set<DartTypeJson>), void>():
            break;
        }

        final pathItem = annotationFragment.paths.putIfAbsent(
          fragmentPart.data.$1.key,
          () {
            return InternOpenapiPathItem();
          },
        );

        final pathEntry = fragmentPart.data.$1;
        final fragmentPathitem = pathEntry.value;
        // TODO bad, but works. Need a way to check if
        // TODO merge would fail to know if schemas are allowed to be added
        if ((pathItem.get != null && fragmentPathitem.get != null) &&
            (pathItem.put != null && fragmentPathitem.put != null) &&
            (pathItem.post != null && fragmentPathitem.post != null) &&
            (pathItem.delete != null && fragmentPathitem.delete != null) &&
            (pathItem.options != null && fragmentPathitem.options != null) &&
            (pathItem.head != null && fragmentPathitem.head != null) &&
            (pathItem.patch != null && fragmentPathitem.patch != null) &&
            (pathItem.trace != null && fragmentPathitem.trace != null) &&
            (pathItem.query != null && fragmentPathitem.query != null)) {
          continue;
        }

        final mergedResult = pathItem.merge(pathEntry.value);

        partialResult[endpoint] = OpenapiPartialResult(pathEntry: mergedResult);

        annotationFragment.paths[pathEntry.key] = mergedResult;
        annotationFragment.components.schemas.addAll(fragmentPart.data.$2);
      }
    }

    return (annotationFragment, partialResult);
  }
}
