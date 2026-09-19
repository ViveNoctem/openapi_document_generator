import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/fragment/open_api_fragment.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

class OpenApiCombiningBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['openapi.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final fragments = <OpenApiFragment>[];

    final glob = Glob('**/*.tmp.openapi.json');

    await for (final input in buildStep.findAssets(glob)) {
      final content = await buildStep.readAsString(input);
      try {
        final openApiFragment = OpenApiFragment.fromJson(jsonDecode(content));
        fragments.add(openApiFragment);
      } catch (e) {}
    }

    if (fragments.isEmpty) return;

    final OpenApiPaths openApiPaths = {};

    for (final fragment in fragments) {
      for (final MapEntry(:key, :value) in fragment.paths.entries) {
        if (openApiPaths.containsKey(key)) {
          // TODO Path exists multiple times
          continue;
        }

        openApiPaths[key] = value;
      }
    }

    final info = OpenApiInfo(title: "title", version: "version");

    final resultSpec = OpenApiSpec(
      info: info,
      paths: openApiPaths,
      openapi: .openApi320,
    );

    final validation = resultSpec.validate("");

    switch (validation) {
      case FailureOf<void, ValidationErrors>():
        log.severe(
          "OpenApiBuilder: found the following errors during validation:",
        );
        for (final error in validation.failure.validations) {
          log.severe("OpenApiBuilder: " + error.path + ": " + error.error);
        }
      case SuccessOf<void, ValidationErrors>():
    }

    // Ausgabe in lib/openapi.json schreiben
    final outputId = AssetId(buildStep.inputId.package, 'lib/openapi.json');
    final encoder = const JsonEncoder.withIndent('  ');
    await buildStep.writeAsString(outputId, encoder.convert(resultSpec));
  }
}
