import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:open_api_spec_builder/open_api_spec_builder.dart';

@AOpenapiEndpoint(
  responses: [
    AOpenapiResponse(
      statusCode: HttpStatus.ok,
      description: 'Description for OK',
    ),
  ],
  path: '/',
  httpMethod: 'GET',
)
Response onRequest(RequestContext context) {
  return Response(body: 'Welcome to Dart Frog!');
}
