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
  )
  SomethingClass? temp,
) {
  return Response(body: 'Welcome to Dart Frog!');
}

class const SomethingClass(
  final int a,
  final SomethingClass2 d, {
  final String b = 'hallo',
}) {}

class SomethingClass2 {
  final double c;

  const SomethingClass2(this.c);
}
