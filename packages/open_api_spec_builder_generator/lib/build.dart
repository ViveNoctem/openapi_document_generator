import 'package:build/build.dart';
import 'package:open_api_spec_builder_generator/src/builder/open_api_combining_builder.dart';
import 'package:open_api_spec_builder_generator/src/builder/open_api_fragment_builder.dart';

Builder openapiFragmentBuilder(BuilderOptions options) =>
    OpenApiFragmentBuilder();

Builder openapiCombiningBuilder(BuilderOptions options) =>
    OpenApiCombiningBuilder();
