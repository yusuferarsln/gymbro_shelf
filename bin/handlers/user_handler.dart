import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'firebase_handler.dart';

class UserHandler {
  UserHandler();
  Future<Response> handle(Request r) async {
    final reqBody = await r.readAsString();
    return await _parseEvent(reqBody);
  }

  Future<Response> _parseEvent(String eventDesc) async {
    final Map<String, dynamic> eventMap = jsonDecode(eventDesc);
    final event = eventMap['event'];
    print(event['op']);
    print(event['data']);
    switch (event['op']) {
      case 'INSERT':
      case 'UPDATE':
        final old = event['data']['old'];
        final current = event['data']['new'];
        if (old == null ||
            old['user_name'] != current['user_name'] ||
            old['is_gymbro_admin'] != current['is_gymbro_admin'] ||
            old['is_gym_owner'] != current['is_gym_owner']) {
          return await FirebaseHandler.setClaims(
            uuid: current['fuuid'],
            claims: {
              'id': current['id'],
              'user_name': current['user_name'],
              'is_gymbro_admin': current['is_gymbro_admin'],
              'is_gym_owner': current['is_gymbro_owner'],
            },
          );
        } else {
          print('No change in claims');
          return Response.ok('No change in claims');
        }
    }
    return Response.badRequest();
  }
}
