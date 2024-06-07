import 'dart:convert';

import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<KategoriBarang?> GetKategoriDataBarang(int id) async {
  var request = await http.get(
      Uri.parse('${URLAplikasi.API}/barang/kategori/${id}'),
      headers: {'Authorization': await AuthKey().Get()});

  if (request.statusCode == 200) {
    List<dynamic> parsed = json.decode(request.body);
    KategoriBarang data = KategoriBarang.fromJson(parsed[0]);

    return data;
  } else {
    return null;
  }
}
