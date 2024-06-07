import 'dart:io';

import 'package:aplikasi/functions/barang/edit.dart';
import 'package:aplikasi/functions/barang/get.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/barang/edit.dart';
import 'package:aplikasi/functions/barang/get.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ManagementEditBarang extends StatefulWidget {
  final int id;
  const ManagementEditBarang({super.key, required this.id});

  @override
  State<ManagementEditBarang> createState() =>
      _ManagementEditBarangState(id: id);
}

class _ManagementEditBarangState extends State<ManagementEditBarang> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final int id;

  _ManagementEditBarangState({required this.id});

  String? _selectedFileName;
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();

    getDataBarang(id).then((data) {
      _nameController.text = data!.namaBarang!;
      _hargaController.text = data!.harga!.toString();
      _deskripsiController.text = data!.deskripsi!;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
        _selectedFileName = _selectedFile!.name;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: TopBar(context, title: "Mengubah data barang"),
      body: Center(
        child: FutureBuilder(
          future: getDataBarang(id),
          builder: (BuildContext ctx, AsyncSnapshot<Barang?> snp) {
            switch (snp.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snp.data == null) {
                  return const Text(
                      "Gagal menghubungi server, mohon periksa koneksi anda");
                } else {
                  return _view(ctx, snp.data!);
                }
              default:
                return const Center(
                  child: Text(
                      "Tolong perbarui halaman ini dengan membuka halaman lain dan membuka halaman ini kembali"),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _view(BuildContext ctx, Barang dko) {
    // dko : daftar kategori barang
    return BoxWithMaxWidth(
      maxWidth: 1000,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const H1("Mengubah data barang"),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Barang',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _deskripsiController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Barang',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _hargaController,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _pickFile,
                            child: const Text('Pilih Gambar'),
                          ),
                          if (_selectedFileName != null) ...[
                            Container(
                              width: 300,
                              child: Text(
                                'File dipilih: $_selectedFileName',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ]),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            await _inputData();
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _inputData() async {
    final name = _nameController.text;
    final deskripsi = _deskripsiController.text;
    final harga = double.parse(_hargaController.text);

    if (_selectedFile == null) {
      // Handle error - no file selected
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Please select an image file."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final File file = File(_selectedFile!.path!);

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return const AlertDialog(
          content: Text(
            "Sedang memasukkan data barang",
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        );
      },
    );

    bool success = await editBarang(id, name, deskripsi, harga, file);

    // Close the loading dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Berhasil mengubah data barang"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close the success dialog
                  Navigator.of(context)
                      .pop("reload pls"); // Navigate back to the previous page
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Gagal memasukkan data barang"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close the failure dialog
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    }
  }
}
