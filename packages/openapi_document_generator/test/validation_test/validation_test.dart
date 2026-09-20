import 'package:openapi_document_generator/src/data_classes/open_api_content.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:test/test.dart';

import 'validation.utils.dart';

void main() {
  // final validationUtils = const ValidationUtils();

  group("OpenapiSpec", () {
    test("all required fields return errors", () {
      final faulty = OpenapiDocument();
      final result = runFailingValidation(node: faulty, path: "").validations;

      expect(result.length, equals(2));

      expect(
        result[0],
        ValidationMatcher(type: .required, path: "/openapi.json/openapi"),
      );
      expect(
        result[1],
        ValidationMatcher(type: .required, path: "/openapi.json/info"),
      );
    });

    test("paths must begin with a forward slash", () {
      final faulty = <String, Map<HttpMethod, InternOpenApiOperation>>{
        "temp": {},
      };

      final openApiSpec = OpenapiDocument(paths: faulty).merge(mvOpenApiSpec);
      final result = runFailingValidation(
        node: openApiSpec,
        path: "",
      ).validations;

      expect(result.length, equals(1));
      expect(
        result[0],
        ValidationMatcher(
          type: .malformedField,
          path: "/openapi.json/paths/temp/",
        ),
      );
    });
  });

  group("OpenapiInfo", () {
    test("all required fields return errors", () {
      final faulty = OpenapiInfo();
      final result = runFailingValidation(node: faulty, path: "").validations;

      expect(result.length, equals(2));
      expect(
        result[0],
        ValidationMatcher(type: .required, path: "/info/title"),
      );
      expect(
        result[1],
        ValidationMatcher(type: .required, path: "/info/version"),
      );
    });
  });

  // TODO does not exist at the moment
  // group("OpenApiPathItem", () {
  //   test("all required fields return errors", () {});
  // });

  group("OpenapiOperation", () {
    test("all required fields return errors", () {
      final faulty = InternOpenApiOperation();
      runSuccessfulValidation(node: faulty, path: "");
    });

    test("responses should contain at least one response", () {
      final faulty = InternOpenApiOperation(responses: {});
      final result = runFailingValidation(node: faulty, path: "").validations;
      expect(result.length, equals(1));

      expect(
        result[0],
        ValidationMatcher(type: .required, path: "/operation/responses"),
      );
    });
  });

  group("OpenapiResponse", () {
    test("all required fields return errors", () {
      final faulty = InternOpenApiResponse();
      final result = runFailingValidation(node: faulty, path: "").validations;

      expect(result.length, equals(1));

      expect(
        result[0],
        ValidationMatcher(type: .required, path: "/response/description"),
      );
    });

    test("Openapi 3.2 doesn't require description", () {
      builderContext = BuilderContext(openApiVersionString: "3.2.0");
      final faulty = InternOpenApiResponse();
      runSuccessfulValidation(node: faulty, path: "");
    });
  });

  group("OpenapiMediaType", () {
    test("all required fields return errors", () {
      final faulty = OpenapiMediaType();
      runSuccessfulValidation(node: faulty, path: "");
    });
  });

  group("OpenapiSchema", () {
    test("all required fields return errors", () {
      final faulty = OpenApiSchemaContent();
      runSuccessfulValidation(node: faulty, path: "");
    });
  });
}
