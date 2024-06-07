import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> tambahStokBarang(
    int barangId, int quantity, DateTime TanggalExpired) async {
  var url = Uri.parse("${URLAplikasi.API}/barang/stok/add");

  try {
    /**
       final int? barangID;
      final int? amount;
      final DateTime? expiredDate;
     */
    var paylaod = jsonEncode(StokBarangAddReq(
        barangID: barangId, amount: quantity, expiredDate: TanggalExpired));
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': await AuthKey().Get(),
      },
      body: paylaod,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}

Future<int> kurangiStokBarang(int barangId, int quantity) async {
  var url = Uri.parse("${URLAplikasi.API}/barang/stok/reduce");
  try {
    var payload =
        jsonEncode(StokBarangRedReq(barangId: barangId, amount: quantity));
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': await AuthKey().Get(),
      },
      body: payload,
    );

    if (response.statusCode == 200) {
      return 1;
    } else if (response.statusCode == 400) {
      return 3;
    } else {
      return 2;
    }
  } catch (_) {
    return 2;
  }
}
