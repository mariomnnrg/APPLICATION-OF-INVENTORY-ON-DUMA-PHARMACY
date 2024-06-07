import 'dart:convert';
import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> UpdateAkun(String nama, String email, String password) async {
  var userdata = User(name: nama, email: email, password: password);

  var payload = jsonEncode(userdata.toJson());

  var request = await http.put(Uri.parse("${URLAplikasi.API}/auth/update"),
      headers: {
        'Authorization': await AuthKey().Get(),
        'Content-Type': 'application/json'
      },
      body: payload);

  if (request.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
