import 'package:analyzer/dart/element/element.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_parameter.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:open_api_spec_builder_generator/src/utils/annotation_reader.dart';
import 'package:open_api_spec_builder_generator/src/utils/content.utils.dart';
import 'package:open_api_spec_builder_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

/// TODO Should Read Endpoint and Controller annotation to use the default values
class const AnnotationAnalyzer({
  final AnnotationReader annotationReader = const AnnotationReader(),
  final TypeCheckers typeCheckers = const TypeCheckers(),
  final ContentUtils contentUtil = const ContentUtils(),
}) {
  ResultOf<OpenApiPathEntry, void> readEndpointMethod({
    required AnnotatedElement element,
    required OpenApiFragmentContext context,
  }) {
    if (element.element is! MethodElement &&
        element.element is! TopLevelFunctionElement) {
      return FailureOf(null);
    }

    final openApiEndpoint = annotationReader.readOpenApiEndpoints(
      element.annotation,
    );

    switch (openApiEndpoint) {
      case FailureOf<(String, HttpMethod, InternOpenApiEndpoint), void>():
        return FailureOf(null);
      case SuccessOf<(String, HttpMethod, InternOpenApiEndpoint), void>():
        break;
    }

    final parameters = _readParameters(
      context: context,
      element: element.element,
    );

    InternOpenApiEndpoint subvalue;

    switch (parameters) {
      case FailureOf<List<InternOpenApiParameter>, void>():
        subvalue = openApiEndpoint.data.$3;
      case SuccessOf<List<InternOpenApiParameter>, void>():
        subvalue = openApiEndpoint.data.$3.merge(
          InternOpenApiEndpoint(parameters: parameters.data),
        );
    }

    return SuccessOf((
      openApiEndpoint.data.$1,
      openApiEndpoint.data.$2,
      subvalue,
    ));
  }

  ResultOf<List<InternOpenApiParameter>, void> _readParameters({
    required OpenApiFragmentContext context,
    required Element element,
  }) {
    if (element is! FunctionTypedElement) {
      return FailureOf(null);
    }

    final result = <InternOpenApiParameter>[];

    for (final parameter in element.formalParameters) {
      if (context.options.apiLibrary == .dartFrog) {
        // Skip RequestContext if DartFrog is used
        if (typeCheckers.getDartFrogRequestContextChecker().isExactlyType(
          parameter.type,
        )) {
          continue;
        }
      }

      final parameterAnnotation = typeCheckers
          .getParameterChecker()
          .firstAnnotationOf(parameter, throwOnUnresolved: false);

      final schema = contentUtil.getJsonForContentType(parameter.type);

      final inferredValues = InternOpenApiParameter(
        name: parameter.displayName,
        location: null,
        required: parameter.isRequired,
        schemaType: parameter.type,
        schema: schema,
        // deprecated:
        // description:
      );

      final annotationValues = annotationReader.readOpenApiParameter(
        ConstantReader(parameterAnnotation),
      );

      // is only null if ignored is true
      if (annotationValues == null) {
        continue;
      }

      final merged = annotationValues.merge(inferredValues);

      result.add(merged);
    }

    return SuccessOf(result);
  }
}
