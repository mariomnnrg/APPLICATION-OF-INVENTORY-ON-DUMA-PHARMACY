import 'dart:convert';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

import '../data/models/barang.dart';

Future<List<Barang>?> ListBarang() async {
  var request = await http.get(Uri.parse("${URLAplikasi.API}/barang/"),
      headers: {'Authorization': await AuthKey().Get()});

  if (request.statusCode == 200) {
    List<dynamic> resbody = jsonDecode(request.body);
    List<Barang> parsedresbody =
        resbody.map((dynamic item) => Barang.fromJson(item)).toList();

    return parsedresbody;
  } else {
    return null;
  }
}
