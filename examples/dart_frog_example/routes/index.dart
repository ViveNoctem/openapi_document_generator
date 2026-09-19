import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:open_api_spec_builder/open_api_spec_builder.dart';

@OpenapiEndpoint(
  responses: {
    HttpStatus.ok: OpenapiResponse(
      statusCode: HttpStatus.ok,
      description: 'Description for OK',
    ),
  },
  path: '/',
  httpMethod: 'GET',
)
Response onRequest(
  RequestContext context,
  @OpenapiParameter(
    description: 'description for the temp field',
    location: .query,
    schema: String,
  )
  int? temp,
) {
  return Response(body: 'Welcome to Dart Frog!');
}
