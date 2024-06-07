import 'package:aplikasi/functions/auth/get.dart';
import 'package:aplikasi/functions/auth/selfupdate.dart';
import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/functions/shared/securestorage.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  int id = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    try {
      String? idString = await OtherKeys().Get("id");
      if (idString != null) {
        setState(() {
          id = int.parse(idString);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error retrieving user ID: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: Sidebar(),
      appBar: TopBar(context, title: "Ubah data pengguna $id"),
      body: FutureBuilder<User?>(
        future: GetAkuntInfo(id),
        builder: (BuildContext ctx, AsyncSnapshot<User?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              if (snapshot.data == null) {
                return Center(
                  child: TextButton(
                    child: Text("Gagal Mengambil Data, klik untuk kembali"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }

              _nameController.text = snapshot.data!.name!;
              _emailController.text = snapshot.data!.email!;

              return Center(
                child: BoxWithMaxWidth(
                  maxWidth: 1000,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const H1("Ubah data staff"),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: _passwordConfirmController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Konfirmasi Ulang password',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_passwordConfirmController.text ==
                                            _passwordController.text) {
                                          if (await UpdateAkun(
                                              _nameController.text,
                                              _emailController.text,
                                              _passwordController.text)) {
                                            Navigator.of(context)
                                                .pop("pls reload");
                                          } else {
                                            _showSomething(
                                              context,
                                              'Gagal',
                                              'Gagal mengupdate data, mohon diperiksa koneksi internet anda',
                                            );
                                          }
                                        } else {
                                          _showSomething(
                                            context,
                                            'Password gagal dikonfirmasi',
                                            'Pastikan anda menuliskan password & password konfirmasi yang sama',
                                          );
                                        }
                                      },
                                      child: const Text('Update'),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Kembali'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );

            default:
              return const Center(
                child: Text(
                    "Tolong perbarui halaman ini dengan membuka halaman lain dan membuka halaman ini kembali"),
              );
          }
        },
      ),
    );
  }

  void _showSomething(BuildContext ctx, String message, String submessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
          title: Text(message),
          content: Text(submessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
