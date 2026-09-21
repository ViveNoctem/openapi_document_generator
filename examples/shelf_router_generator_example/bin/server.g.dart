// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ApiServiceRouter(ApiService service) {
  final router = Router();
  router.add('GET', r'/', service._rootHandler);
  router.add('GET', r'/echo/<message>', service._echoHandler);
  return router;
}
