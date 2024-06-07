import 'dart:convert';

import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> UpdateAkunStaff(
    int id, String nama, String email, String password) async {
  var userdata = User(name: nama, email: email, password: password);

  var payload = jsonEncode(userdata.toJson());

  var request = await http.put(
      Uri.parse("${URLAplikasi.API}/user/update/${id}"),
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

/**

{
  "id": 2,
  "name": "margarethtatchers",
  "email": "michaelholmes2@apotekduma.com",
  "password": "$2a$14$kVI6VzGk6LmQwcmJgXa0Pe5UCPjvs.uR2HeTQR70m.S2B6imU8OYO",
  "role": 1
}

 */
