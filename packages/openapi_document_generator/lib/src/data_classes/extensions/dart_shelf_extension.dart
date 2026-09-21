import 'package:openapi_document_generator/src/data_classes/extensions/i_builder_extension.dart';
import 'package:openapi_document_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

class const DartShelfExtension() implements IBuilderExtension {
  @override
  ResultOf<OpenApiFragment, String> getExtensionFragment({
    required Map<OpenapiControllerElement?, List<OpenapiEndpointElement>>
    controllerEndpointMap,
    required Map<
      OpenapiEndpointElement,
      (String, HttpMethod, InternOpenApiOperation)
    >
    partialResult,
  }) {
    // TODO: implement getExtensionFragment
    throw UnimplementedError();
  }
}
