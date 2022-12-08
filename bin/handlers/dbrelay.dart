import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../constants/constants.dart';

class DBRelay {
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
