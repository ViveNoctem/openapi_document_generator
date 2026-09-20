import 'package:build/build.dart';
import 'package:openapi_document_generator/src/builder/openapi_combining_builder.dart';
import 'package:openapi_document_generator/src/builder/openapi_fragment_builder.dart';

Builder openapiFragmentBuilder(BuilderOptions options) =>
    OpenApiFragmentBuilder(options: options);

Builder openapiCombiningBuilder(BuilderOptions options) =>
    OpenApiCombiningBuilder();
