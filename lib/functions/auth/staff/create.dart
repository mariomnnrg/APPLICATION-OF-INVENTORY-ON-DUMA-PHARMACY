import 'dart:convert';

import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> CreateAkunStaff(String name, String email, String password) async {
  var body =
      jsonEncode(User(name: name, email: email, password: password).toJson());
  var request = await http.post(Uri.parse("${URLAplikasi.API}/user/signup"),
      headers: {
        "Authorization": await AuthKey().Get(),
        "Content-Type": "application/json"
      },
      body: body);

  if (request.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
