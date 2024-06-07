import 'package:http/http.dart' as http;
import '../data/urls.dart';
import '../shared/securestorage.dart';

Future<bool> DeleteObat(int id) async {
  var respond = await http.delete(Uri.parse("${URLAplikasi.API}/obat/${id}"),
      headers: {'Authorization': await AuthKey().Get()});

  if (respond.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
