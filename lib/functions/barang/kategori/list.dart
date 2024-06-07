import 'dart:convert';

import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<List<KategoriBarang>?> ListKategoriBarang() async {
  var request = await http.get(Uri.parse("${URLAplikasi.API}/barang/kategori/"),
      headers: {'Authorization': await AuthKey().Get()});

  if (request.statusCode == 200) {
    List<dynamic> resbody = jsonDecode(request.body);
    List<KategoriBarang> parsedresbody =
        resbody.map((dynamic item) => KategoriBarang.fromJson(item)).toList();

    return parsedresbody;
  } else {
    return null;
  }
}
