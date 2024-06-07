import "dart:convert";
import "package:aplikasi/functions/data/models/barang.dart";
import "package:aplikasi/functions/data/urls.dart";
import "package:aplikasi/functions/shared/securestorage.dart";
import "package:http/http.dart" as http;

Future<bool> CreateKategoriBarang(String nama_kategori) async {
  try {
    var req = await http.post(
        Uri.parse(
          "${URLAplikasi.API}/barang/kategori/",
        ),
        headers: {
          'Authorization': await AuthKey().Get(),
          'Content-Type': 'application/json'
        },
        body: jsonEncode(KategoriBarang(namaKategoriBarang: nama_kategori)));

    if (req.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
