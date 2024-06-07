import 'dart:convert';

import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<User?> GetAkuntInfo(int id) async {
  var key = await AuthKey().Get();
  var req = await http.get(Uri.parse("${URLAplikasi.API}/user/details/${id}"),
      headers: {'Authorization': key, 'Content-Type': 'application/json'});

  print(key);
  if (req.statusCode == 200) {
    User parsed = User.fromJson(jsonDecode(req.body));
    return parsed;
  } else {
    return null;
  }
}
