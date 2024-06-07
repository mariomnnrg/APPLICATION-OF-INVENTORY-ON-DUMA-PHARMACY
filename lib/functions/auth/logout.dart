import 'package:aplikasi/functions/data/urls.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:http/http.dart' as http;

Future<bool> Logout() async {
  String? finale = await AuthKey().Get();

  // ignore: unnecessary_null_comparison
  if (finale != null) {
    final url = Uri.parse('${URLAplikasi.API}/auth/logout');
    final request = await http.post(url, headers: {'Authorization': finale});
    await AuthKey().Clear(); // clearing the stored token
    await OtherKeys().Clear(); // clearing the stored
    return true;
  }
  return false;
}
