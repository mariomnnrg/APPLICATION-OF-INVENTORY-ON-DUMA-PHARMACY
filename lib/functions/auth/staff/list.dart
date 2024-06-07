import 'dart:convert';

import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<List<User>?> GetListStaff() async {
  var key = await AuthKey().Get();
  var request =
      await http.get(Uri.parse("${URLAplikasi.API}/user/list"), headers: {
    "Authorization": key,
  });

  print(request.statusCode);
  if (request.statusCode == 200) {
    List<dynamic> decres = jsonDecode(request.body);
    List<User> userlist = decres.map((dynamic i) => User.fromJson(i)).toList();

    return userlist;
  } else {
    return null;
  }
}
