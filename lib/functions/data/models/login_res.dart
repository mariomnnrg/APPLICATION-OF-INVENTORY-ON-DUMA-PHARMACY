// json models
import 'package:aplikasi/functions/data/models/user.dart';

class LoginRes {
  final int? status;
  final String? token;
  final User? user;

  LoginRes({this.status, this.token, this.user});

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
        status: json['id'], token: json['token'], user: User.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'token': token,
      'user': user!.toJson(),
    };
  }
}
