import 'package:analyzer/dart/element/element.dart';
import 'package:open_api_spec_builder_generator/src/annotation_reader/annotation_reader.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:source_gen/source_gen.dart';

/// TODO Should Read Endpoint and Controller annotation to use the default values
class const AnnotationAnalyzer({
  final AnnotationReader annotationReader = const AnnotationReader(),
}) {
  ResultOf<OpenApiPathEnty, void> readEndpointMethod(AnnotatedElement element) {
    if (element.element is! MethodElement) {
      return FailureOf(null);
    }

    final openApiEndpoint = annotationReader.readOpenApiEndpoints(element);
    return openApiEndpoint;
  }
}
