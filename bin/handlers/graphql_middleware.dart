import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../constants/constants.dart';

class DBHandler {
  DBHandler();
  Middleware authMiddleWare() => (Handler innerHandler) {
        return (Request r) async {
          final isAuthorized = await _authCheck(r);
          if (isAuthorized) {
            return innerHandler(r);
          } else {
            print("rejected");
            return Response.forbidden("unauthorized");
          }
        };
      };

  static Future<bool> _authCheck(Request request) async {
    if (request.headers.containsKey("Bearer")) {
      Map<String, String> token = {
        "idToken": "${request.headers['Bearer']}",
      };
      final response = await http.post(
        Uri.parse(AppConstants.firebaseSDKUrl),
        body: jsonEncode(token),
      );

      if (response.statusCode == 200) {
        /*request.headers["X-Hasura-User-Id"] = jsonDecode(response.body)["id"];
        request.headers["X-Hasura-Role"] = "user";*/
        return true;
      }
    }
    return true;
  }

  Future<Response> graphqlRelay(Request r) async {
    final hResponse = await http.post(Uri.parse(AppConstants.internalHasuraUrl),
        body: await r.readAsString(), headers: {});

    // print(hResponse.body);
    Map decodedBody = jsonDecode(hResponse.body);
    if (decodedBody.keys.first == 'data') {
      return Response.ok(hResponse.body);
    } else {
      return Response.forbidden(hResponse.body);
    }
  }
}
