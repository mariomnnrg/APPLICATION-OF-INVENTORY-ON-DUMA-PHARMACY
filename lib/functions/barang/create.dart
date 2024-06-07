import 'dart:convert';

import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<bool> createBarangData(String namaBarang, int jumlah, String deskripsi,
    double harga, List<int?> idKategoriBarang, File imageFile) async {
  final url = "${URLAplikasi.API}/barang/"; // Replace with your API endpoint

  final request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers["Authorization"] = await AuthKey().Get();
  request.headers["Content-Type"] = "multipart/form-data";

  // Add your JSON data
  request.fields["data"] = jsonEncode({
    "kategori_barang": idKategoriBarang,
    "data_barang": Barang(
            namaBarang: namaBarang,
            deskripsi: deskripsi,
            jumlahStok: jumlah,
            harga: harga)
        .toJson()
  });

  // Add the image file
  request.files.add(http.MultipartFile(
      'image', // Field name for the image
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: "image.jpeg"));

  // Send the request
  final response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


/**


 */