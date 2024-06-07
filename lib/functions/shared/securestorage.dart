import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthKey {
  final _secure_storage = new FlutterSecureStorage();

  Future<String> Get() async {
    String? data = await _secure_storage.read(key: "auth_key");
    if (data != null) {
      return data;
    } else {
      return "";
    }
  }

  Future<bool> Set(String value) async {
    try {
      await _secure_storage.write(key: "auth_key", value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> Clear() async {
    try {
      await _secure_storage.delete(key: "auth_key");
    } catch (e) {
      throw e;
    }
  }
}

class OtherKeys {
  final _secure_storage = new FlutterSecureStorage();

  Future<String?> Get(String key) async {
    return await _secure_storage.read(key: key);
  }

  Future<void> Set(String key, String value) async {
    try {
      await _secure_storage.write(key: key, value: value);
    } catch (e) {
      throw e;
    }
  }

  Future<void> Delete(String key) async {
    try {
      await _secure_storage.delete(key: key);
    } catch (e) {
      throw e;
    }
  }

  Future<void> Clear() async {
    try {
      await _secure_storage.deleteAll();
    } catch (e) {
      throw e;
    }
  }
}
