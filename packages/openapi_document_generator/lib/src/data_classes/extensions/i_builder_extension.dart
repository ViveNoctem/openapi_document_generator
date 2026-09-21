import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:openapi_document_annotation/openapi_document_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_partial_result.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:source_gen/source_gen.dart';

/// TODO maybe have the ability to make extension for shelf, dart_frog, alfred, serverpod, etc
/// TODO this could infer more information directly  from the code instead of everything being in the annotations
/// TODO this could add values to fields not provided in the annotations
/// TODO add opsions to build.yaml to set which library is used
abstract interface class IBuilderExtension {
  /// Description
  ///
  /// [controllerEndpointMap] key is an ClassElement annotated with [OpenapiController]
  /// value is the List of all [OpenapiEndpoint] annotated Elements in this class
  /// The value for a [Null] key returns all [OpenapiEndpoint]s without an [OpenapiController]
  ///
  /// [partialResult] contains everything the builder knows so far about each [OpenapiEndpointElement]
  /// can be used to infer information not possible otherwise
  Future<ResultOf<OpenApiFragment, String>> getExtensionFragment({
    required Map<
      ClassElement?,
      (List<OpenapiEndpointElement>, InternOpenapiController?)
    >
    controllerEndpointMap,
    required Map<OpenapiEndpointElement, OpenapiPartialResult> partialResult,
    required BuildStep buildStep,
  });
}

extension type OpenapiEndpointElement(final AnnotatedElement element) {}
