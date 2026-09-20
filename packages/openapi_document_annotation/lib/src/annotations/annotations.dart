class AOpenapiController {
  //TODO baseRoute
  final String? summary;

  // TODO added to all endpoints in controller
  final List<OpenapiResponse> responses;

  const AOpenapiController({this.summary, this.responses = const []});
}

const openapiController = AOpenapiController();

class const OpenapiEndpoint({
  required final Map<int, OpenapiResponse> responses,
  required final String path,
  required final String httpMethod,
}) {
  // TODO endpoint route
  // TODO allow for Endpoints without Controller in class
}

class const OpenapiResponse({
  // TODO required as long as i can't autogen it from comments
  required final String? description,
  final Type? resultType,
}) {
  // TODO autogen type and statusCode 200 if not supplied
  // TODO only if return type is a 'real' class
}

// TODO save all components in a big list to create all the references in one list.
// TODO duplicates should not be added
// TODO

class const OpenapiParameter({
  final String? name,
  final OpenApiParameterLocation? location,
  final String? description,
  final bool? required,
  final bool? deprecated,
  final bool ignoreParameter = false,
  final Type? schema,

  /// TODO content does not work at the moment use schema
  @Deprecated("content does not work at the moment use schema")
  final String? content,
}) {}

enum const OpenApiParameterLocation(final String value) {
  query("query"),
  querystring("querystring"),
  header("header"),
  path("path"),
  cookie("cookie");

  static OpenApiParameterLocation fromValue(String value) {
    return values.firstWhere((s) => s.value == value);
  }
}
