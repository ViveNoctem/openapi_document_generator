import 'dart:convert';

import 'package:build/build.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_builder_options.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_components_fragment.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:open_api_spec_builder_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation_analyzer.dart';

class OpenApiFragmentBuilder implements Builder {
  final BuilderOptions options;
  final TypeCheckers typeCheckers;
  final AnnotationAnalyzer annotationAnalyzer;
  late final OpenApiBuilderOptions builderOptions;

  OpenApiFragmentBuilder({
    required this.options,
    this.typeCheckers = const TypeCheckers(),
    this.annotationAnalyzer = const AnnotationAnalyzer(),
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

    final typeChecker = typeCheckers.getEndpointChecker();
    final annotatedElements = reader.annotatedWith(typeChecker);
    final context = OpenApiFragmentContext(options: builderOptions);

    if (annotatedElements.isEmpty) return;

    final OpenApiPaths paths = {};
    final OpenApiComponentsFragment components = OpenApiComponentsFragment(
      schemas: {},
    );

    for (final annotatedElement in annotatedElements) {
      final fragmentPart = annotationAnalyzer.readEndpointMethod(
        element: annotatedElement,
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

    // Wenn wir keine validen Klassen gefunden haben, überspringen
    if (paths.isEmpty) return;

    final result = OpenApiFragment(paths: paths, components: components);

    // 5. JSON als Datei schreiben
    final outputId = buildStep.inputId.changeExtension('.tmp.openapi.json');
    await buildStep.writeAsString(outputId, jsonEncode(result));
  }
}
