import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:source_gen/source_gen.dart';

class const InternOpenapiController({
  final String? summary,
  final Map<int, InternOpenApiResponse>? responses,
  final String? basePath,

  /// Function or Variable returning the router for this controller.
  ///
  /// Only used if the shelf extension is activated
  /// All added routes will use [basePath]
  final ConstantReader? shelfRouter,
}) {}
