import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers/dbrelay.dart';

// Configure routes.

void main(List<String> args) async {
  final queryHandler = DBRelay();

  print(pid);
  final app = Router();
  app.post("/dbRelay", queryHandler.graphqlRelay);

  final appPipe = const Pipeline()
      .addMiddleware(
        (innerHandler) => (request) async {
          final response = await innerHandler(request);
          return response.change(headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': '*',
            'Access-Control-Expose-Headers': '*',
          });
        },
      )
      .addHandler(app);

  await serve(
    appPipe,
    'localhost',
    8080,
  );
  print('server created');
}
