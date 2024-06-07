import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> DeleteAkunStaff(int id) async {
  var req = await http.delete(Uri.parse("${URLAplikasi.API}/user/${id}"),
      headers: {"Authorization": await AuthKey().Get()});

  if (req.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
