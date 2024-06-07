import 'dart:convert';

import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:http/http.dart' as http;

import '../shared/securestorage.dart';

Future<Obat?> getDataObat(int id) async {
  var request = await http.get(Uri.parse('${URLAplikasi.API}/obat/${id}'),
      headers: {'Authorization': await AuthKey().Get()});

  if (request.statusCode == 200) {
    List<dynamic> parsed = json.decode(request.body);
    Obat data = Obat.fromJson(parsed[0]);

    return data;
  } else {
    return null;
  }
}
