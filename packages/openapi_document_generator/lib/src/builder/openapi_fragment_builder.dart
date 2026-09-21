import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_builder_options.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
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
    final controllerChecker = typeCheckers.getControllerTypeChecker();
    final annotatedElements = reader.annotatedWith(endPointChecker);
    final context = OpenApiFragmentContext(options: builderOptions);

    if (annotatedElements.isEmpty) return;

    final OpenApiPaths paths = {};
    final OpenApiComponentsFragment components = OpenApiComponentsFragment(
      schemas: {},
    );

    final allTypes =
        <ClassElement?, (List<AnnotatedElement>, InternOpenapiController?)>{};

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
      classEndpoint.$1.add(annotatedElement);
    }

    for (final MapEntry(
          key: classElement,
          value: (endpoints, controllerAnnotation),
        )
        in allTypes.entries) {
      for (final endpoint in endpoints) {
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

        final map = paths.putIfAbsent(fragmentPart.data.$1.$1, () {
          return {};
        });

        if (map.containsKey(fragmentPart.data.$2)) {
          // TODO same path same method
          continue;
        }

        components.schemas.addAll(fragmentPart.data.$2);

        map[fragmentPart.data.$1.$2] = fragmentPart.data.$1.$3;
      }
    }

    // Wenn wir keine validen Klassen gefunden haben, überspringen
    if (paths.isEmpty) return;

    final result = OpenApiFragment(paths: paths, components: components);

    // 5. JSON als Datei schreiben
    final outputId = buildStep.inputId.changeExtension('.tmp.openapi.json');
    await buildStep.writeAsString(outputId, jsonEncode(result));
  }
}
