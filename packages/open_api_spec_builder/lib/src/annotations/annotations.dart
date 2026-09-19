class AOpenapiController {
  //TODO baseRoute
  final String? summary;

  // TODO added to all endpoints in controller
  final List<AOpenapiResponse> responses;

  const AOpenapiController({this.summary, this.responses = const []});
}

const openapiController = AOpenapiController();

class const AOpenapiEndpoint({
  final List<AOpenapiResponse> responses = const [],
  required final String path,
  required final String httpMethod,
}) {
  // TODO endpoint route
  // TODO allow for Endpoints without Controller in class
}

class const AOpenapiResponse({
  required final int statusCode,
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
