import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers/dbrelay.dart';
import 'handlers/user_handler.dart';

// Configure routes.

void main(List<String> args) async {
  final queryHandler = DBRelay();
  final userHandler = UserHandler();

  print(pid);
  final app = Router();
  app.post("/dbRelay", queryHandler.graphqlRelay);
  app.post("/eventHandler", userHandler.handle);

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
    InternetAddress.anyIPv4,
    443,
  );
  print('server created');
}
