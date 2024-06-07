import 'dart:convert';
import 'dart:io';
import 'package:aplikasi/functions/data/models/barang.dart';
import '../data/urls.dart';
import 'package:http/http.dart' as http;
import '../shared/securestorage.dart';

Future<bool> editBarang(
  int id,
  String namaBarang,
  String deskripsi,
  double harga,
  File imageFile,
) async {
  final url =
      "${URLAplikasi.API}/barang/${id}"; // Replace with your API endpoint

  final request = http.MultipartRequest('PUT', Uri.parse(url));
  request.headers["Authorization"] = await AuthKey().Get();
  request.headers["Content-Type"] = "multipart/form-data";

  // Add your JSON data
  request.fields["data"] = jsonEncode(
      Barang(namaBarang: namaBarang, deskripsi: deskripsi, harga: harga)
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
