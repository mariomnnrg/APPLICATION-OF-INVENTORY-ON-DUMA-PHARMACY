import 'package:aplikasi/functions/barang/kategori/create.dart';
import 'package:aplikasi/functions/obat/kategori/create.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:flutter/material.dart';

class ManagementCreateKategoriBarang extends StatefulWidget {
  const ManagementCreateKategoriBarang({super.key});

  @override
  State<ManagementCreateKategoriBarang> createState() =>
      _ManagementCreateKategoriBarangState();
}

class _ManagementCreateKategoriBarangState
    extends State<ManagementCreateKategoriBarang> {
  final TextEditingController _namaKategoriBarangController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: TopBar(context, title: "Menambahkan Kategori"),
      body: Center(
        child: BoxWithMaxWidth(
          maxWidth: 1000,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const H1("Menambahkan Kategori"),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        TextField(
                          controller: _namaKategoriBarangController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Kategori',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                await DoCreateKategori(context,
                                    _namaKategoriBarangController.text);
                              },
                              child: const Text('Simpan'),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Kembali'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> DoCreateKategori(BuildContext ctx, String nama) async {
    if (await CreateKategoriBarang(nama)) {
      Navigator.of(context).pop("reload pls");
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              content: const Text("Tidak dapat menambahkan kategori"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            );
          });
    }
  }
}
