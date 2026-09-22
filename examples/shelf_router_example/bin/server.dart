import 'dart:io';

import 'package:openapi_document_annotation/openapi_document_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

@OpenapiController(/*shelfRouter: _getRouter*/)
class RouterClass {
  static Response rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  @OpenapiEndpoint(
    responses: {
      HttpStatus.accepted: OpenapiResponse(
        description: 'asdsad',
        mediaType: 'application/pdf',
      ),
    },
  )
  static Response echoHandler(
    Request request,
    String message,
    SomethingClass2 d,
  ) {
    // final message = request.params['message'];
    return Response.ok('$message\n');
  }

  // Router get router => Router()..get("/", rootHandler);

  late final Handler handler = (Router()..get("/", echoHandler)).call;
}

@Route.connect("")
Router _getRouter() {
  // Configure routes.
  final router = Router();
  router.get('/', RouterClass.rootHandler);
  router.get('/echo/<message>', RouterClass.echoHandler);

  return router;
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  // final handler = Pipeline()
  //     .addMiddleware(logRequests())
  //     .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  // final port = int.parse(Platform.environment['PORT'] ?? '8080');
  // final server = await serve(handler, ip, port);
  // print('Server listening on port ${server.port}');
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
