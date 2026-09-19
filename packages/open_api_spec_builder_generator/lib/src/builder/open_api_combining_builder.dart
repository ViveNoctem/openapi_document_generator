import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

class OpenApiCombiningBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['openapi.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final combinedSchemas = <String, dynamic>{};

    // Glob sucht nach allen Part-Dateien, die Builder 1 generiert hat
    final glob = Glob('**/*.tmp.openapi.json');

    await for (final input in buildStep.findAssets(glob)) {
      final content = await buildStep.readAsString(input);
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Hier fügst du die Daten aus den Fragmenten zusammen
      combinedSchemas.addAll(json);
    }

    // Falls keine Dateien gefunden wurden, brechen wir ab
    if (combinedSchemas.isEmpty) return;

    final finalOpenApiSpec = {
      "openapi": "3.0.0",
      "info": {"title": "Generated API", "version": "1.0.0"},
      "components": {"schemas": combinedSchemas},
    };

    // Ausgabe in lib/openapi.json schreiben
    final outputId = AssetId(buildStep.inputId.package, 'lib/openapi.json');
    await buildStep.writeAsString(outputId, jsonEncode(finalOpenApiSpec));
  }
}
