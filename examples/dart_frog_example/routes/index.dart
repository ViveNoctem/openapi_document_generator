import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:openapi_document_annotation/openapi_document_annotation.dart';

@OpenapiEndpoint(
  responses: {
    HttpStatus.accepted: OpenapiResponse(
      description: 'Description for accepted',
      mediaType: 'application/json',
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
