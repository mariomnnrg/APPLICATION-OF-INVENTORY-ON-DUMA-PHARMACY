import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> DeleteKategoriBarang(int id) async {
  var respond = await http.delete(
      Uri.parse("${URLAplikasi.API}/barang/kategori/${id}"),
      headers: {'Authorization': await AuthKey().Get()});

  if (respond.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
