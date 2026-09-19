import 'dart:convert';

import 'package:build/build.dart';
import 'package:open_api_spec_builder_generator/src/builder/type_checkers.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation_analyzer.dart';

class OpenApiFragmentBuilder({
  final TypeCheckers typeCheckers = const TypeCheckers(),
  final AnnotationAnalyzer annotationAnalyzer = const AnnotationAnalyzer(),
}) implements Builder {
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

    if (annotatedElements.isEmpty) return;

    final OpenApiPaths paths = {};

    for (final annotatedElement in annotatedElements) {
      final fragmentPart = annotationAnalyzer.readEndpointMethod(
        annotatedElement,
      );

      switch (fragmentPart) {
        case FailureOf<OpenApiPathEnty, void>():
          continue;
        case SuccessOf<OpenApiPathEnty, void>():
          break;
      }

      if (paths.containsKey(fragmentPart.data.key)) {
        // TODO Path already exists
        continue;
      }

      paths[fragmentPart.data.key] = fragmentPart.data.value;
    }

    // Wenn wir keine validen Klassen gefunden haben, überspringen
    if (paths.isEmpty) return;

    final result = OpenApiFragment(paths: paths);

    // 5. JSON als Datei schreiben
    final outputId = buildStep.inputId.changeExtension('.tmp.openapi.json');
    await buildStep.writeAsString(outputId, jsonEncode(result));
  }
}
