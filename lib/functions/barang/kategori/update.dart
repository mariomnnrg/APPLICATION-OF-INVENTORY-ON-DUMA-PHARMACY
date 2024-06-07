import 'dart:convert';

import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> UpdateKategoriBarang(int id, KategoriBarang data) async {
  var payload = jsonEncode(data.toJson());
  var request = await http.put(
      Uri.parse("${URLAplikasi.API}/barang/kategori/${id}"),
      body: payload,
      headers: {
        'Authorization': await AuthKey().Get(),
        'Content-Type': 'application/json'
      });

  if (request.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
