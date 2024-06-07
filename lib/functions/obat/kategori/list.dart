import 'dart:convert';

import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<List<KategoriObat>?> ListKategoriObat() async {
  var request = await http.get(Uri.parse("${URLAplikasi.API}/obat/kategori/"),
      headers: {'Authorization': await AuthKey().Get()});

  if (request.statusCode == 200) {
    List<dynamic> resbody = jsonDecode(request.body);
    List<KategoriObat> parsedresbody =
        resbody.map((dynamic item) => KategoriObat.fromJson(item)).toList();

    return parsedresbody;
  } else {
    return null;
  }
}
