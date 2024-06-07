import 'dart:convert';
import 'dart:io';

import 'package:aplikasi/functions/data/models/obat.dart';

import '../data/urls.dart';
import 'package:http/http.dart' as http;

import '../shared/securestorage.dart';

Future<bool> editObat(String namaObat, String dosis, String bentukSediaan,
    double harga, File imageFile, int id) async {
  final url = "${URLAplikasi.API}/obat/${id}"; // Replace with your API endpoint

  final request = http.MultipartRequest('PUT', Uri.parse(url));
  request.headers["Authorization"] = await AuthKey().Get();
  request.headers["Content-Type"] = "multipart/form-data";

  // Add your JSON data
  request.fields["data"] = jsonEncode(Obat(
          namaObat: namaObat,
          dosisObat: dosis,
          bentukSediaan: bentukSediaan,
          hargaSediaan: harga)
      .toJson());

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
