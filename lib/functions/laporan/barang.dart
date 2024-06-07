import 'dart:convert';

import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<List<StokMasukBarang>?> fetchLaporanMasukStokBarang() async {
  try {
    var fetchData = await http
        .get(Uri.parse("${URLAplikasi.API}/barang/stok/add/history"), headers: {
      'Accept': 'application/json',
      'Authorization': await AuthKey().Get()
    });

    if (fetchData.statusCode == 200) {
      List<dynamic> data = jsonDecode(fetchData.body);
      List<StokMasukBarang> compiledData =
          data.map((x) => StokMasukBarang.fromJson(x)).toList();

      return compiledData;
    } else {
      return null;
    }
  } catch (e) {
    print("Exception $e");
    return null;
  }
}

Future<List<StokKeluarBarang>?> fetchLaporanKeluarStokBarang() async {
  try {
    var fetchData = await http.get(
      Uri.parse("${URLAplikasi.API}/barang/stok/reduce/history"),
      headers: {
        'Accept': 'application/json',
        'Authorization': await AuthKey().Get()
      },
    );

    if (fetchData.statusCode == 200) {
      List<dynamic> data = jsonDecode(fetchData.body);
      return data.map((x) => StokKeluarBarang.fromJson(x)).toList();
    } else {
      print("Error: ${fetchData.statusCode}");
      return null;
    }
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}
