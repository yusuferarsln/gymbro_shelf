import 'dart:convert';

import 'package:firebase_admin/firebase_admin.dart';
import 'package:shelf/shelf.dart';

class FirebaseHandler {
  static final _firebase = FirebaseAdmin.instance.initializeApp(
    AppOptions(
      credential: Credentials.applicationDefault()!,
    ),
  );

  Future<Response> setClaims({
    required String uuid,
    required Map<String, dynamic> claims,
  }) async {
    print('updating claims for $uuid');
    print('new claims: $claims');
    await _firebase.auth().setCustomUserClaims(uuid, claims);
    final user = await _firebase.auth().getUser(uuid);
    return Response.ok(jsonEncode(user.toJson()));
  }

  static Future<Response> disableUser(String uuid) async {
    final user = await _firebase.auth().updateUser(uuid, disabled: true);
    return Response.ok(jsonEncode(user.toJson()));
  }
}
