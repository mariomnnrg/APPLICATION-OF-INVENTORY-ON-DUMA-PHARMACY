import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi/functions/auth/login.dart' as login;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 200, horizontal: 50),
                  child: Column(children: [
                    const H1('Halo! 👋'),
                    const SizedBox(height: 15),
                    const Text(
                        'Silahkan login terlebih dahulu sebelum melanjutkan'),
                    const SizedBox(height: 50),
                    TextField(
                        controller: _emailInputController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        )),
                    const SizedBox(height: 20),
                    TextField(
                        controller: _passwordInputController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password_outlined),
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          await DoLogin(context, _emailInputController.text,
                              _passwordInputController.text);
                        },
                        child: const Text("Submit"))
                  ]))),
        ],
      ))),
    );
  }

  Future<void> DoLogin(
      BuildContext context, String email, String password) async {
    try {
      bool login_res = await login.Login(email, password);

      if (login_res) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Dashboard()));
        // true (login berhasil)
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Gagal masuk"),
                  content: const Text("Periksa alamat surel, katasandi anda"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("OK"))
                  ],
                ));
        // false (login berhasil)
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Tidak dapat terhubung dengan jaringan"),
                content: const Text("Mohon periksa koneksi anda"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("OK"))
                ],
              ));
    }
  }
}
