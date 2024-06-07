import 'package:aplikasi/functions/barang/kategori/get.dart';
import 'package:aplikasi/functions/barang/kategori/update.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/obat/kategori/get.dart';
import 'package:aplikasi/functions/obat/kategori/update.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:flutter/material.dart';

class ManagementEditKategoriBarang extends StatefulWidget {
  final int id;

  const ManagementEditKategoriBarang({
    Key? key,
    required this.id,
  });

  @override
  State<ManagementEditKategoriBarang> createState() =>
      _ManagementEditKategoriBarangState(id: id);
}

class _ManagementEditKategoriBarangState
    extends State<ManagementEditKategoriBarang> {
  final TextEditingController _namaController = TextEditingController();

  final int id;

  _ManagementEditKategoriBarangState({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Sidebar(),
        appBar: TopBar(context, title: "Edit Kategori"),
        body: FutureBuilder(
            future: GetKategoriDataBarang(id),
            builder:
                (BuildContext ctx, AsyncSnapshot<KategoriBarang?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  {
                    return const Center(child: CircularProgressIndicator());
                  }

                case ConnectionState.done:
                  {
                    if (snapshot.data == null) {
                      return const Center(
                        child: Text("Mohon periksa koneksi internet anda"),
                      );
                    } else {
                      _namaController.text = snapshot.data!.namaKategoriBarang!;

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
                                  const H1("Edit Kategori"),
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: _namaController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nama Obat',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            KategoriBarang payload =
                                                KategoriBarang(
                                                    namaKategoriBarang:
                                                        _namaController.text);
                                            UpdateKategoriBarang(id, payload)
                                                .then((status) {
                                              if (status) {
                                                Navigator.of(context)
                                                    .pop('do refresh');
                                              } else {
                                                _showFailedDialog();
                                              }
                                            });
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                default:
                  {
                    return const Center(
                      child: Text(
                          "Tolong perbarui halaman ini dengan membuka halaman lain dan membuka halaman ini kembali"),
                    );
                  }
              }
            }));
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Gagal mengubah data',
          ),
          content: const Text(
            'Mohon periksa internet anda',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
