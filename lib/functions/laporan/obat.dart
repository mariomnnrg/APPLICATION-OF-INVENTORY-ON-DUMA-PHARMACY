import 'dart:convert';

import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<List<StokMasukObat>?> fetchLaporanMasukStokObat() async {
  try {
    var fetchData = await http
        .get(Uri.parse("${URLAplikasi.API}/obat/stok/add/history"), headers: {
      'Accept': 'application/json',
      'Authorization': await AuthKey().Get()
    });

    if (fetchData.statusCode == 200) {
      List<dynamic> data = jsonDecode(fetchData.body);
      List<StokMasukObat> compiledData =
          data.map((x) => StokMasukObat.fromJson(x)).toList();

      return compiledData;
    } else {
      return null;
    }
  } catch (e) {
    print("Exception $e");
    return null;
  }
}

Future<List<StokKeluarObat>?> fetchLaporanKeluarStokObat() async {
  try {
    var fetchData = await http.get(
      Uri.parse("${URLAplikasi.API}/obat/stok/reduce/history"),
      headers: {
        'Accept': 'application/json',
        'Authorization': await AuthKey().Get()
      },
    );

    if (fetchData.statusCode == 200) {
      List<dynamic> data = jsonDecode(fetchData.body);
      return data.map((x) => StokKeluarObat.fromJson(x)).toList();
    } else {
      print("Error: ${fetchData.statusCode}");
      return null;
    }
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}
