import 'dart:convert';

import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi/functions/data/models/obat.dart';

Future<bool> UpdateKategoriObat(int id, KategoriObat data) async {
  var payload = jsonEncode(data.toJson());
  var request = await http.put(
      Uri.parse("${URLAplikasi.API}/obat/kategori/${id}"),
      body: payload,
      headers: {
        'Authorization': await AuthKey().Get(),
        'Content-Type': 'application/json'
      });

  if (request.statusCode == 200) {
    return true;
  }

  print(request.statusCode);

  return false;
}
