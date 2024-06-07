import 'dart:io';

import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/obat/edit.dart';
import 'package:aplikasi/functions/obat/get.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ManagementEditObat extends StatefulWidget {
  final int id;
  const ManagementEditObat({super.key, required this.id});

  @override
  State<ManagementEditObat> createState() => _ManagementEditObatState(id: id);
}

class _ManagementEditObatState extends State<ManagementEditObat> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _bentukSediaanController =
      TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final int id;

  _ManagementEditObatState({required this.id});

  String? _selectedFileName;
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();

    getDataObat(id).then((data) {
      _nameController.text = data!.namaObat!;
      _dosisController.text = data!.dosisObat!;
      _bentukSediaanController.text = data!.bentukSediaan!;
      _hargaController.text = (data!.hargaSediaan!).toString();
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
      appBar: TopBar(context, title: "Mengubah data Obat"),
      body: Center(
        child: FutureBuilder(
          future: getDataObat(id),
          builder: (BuildContext ctx, AsyncSnapshot<Obat?> snp) {
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

  Widget _view(BuildContext ctx, Obat dko) {
    // dko : daftar kategori obat
    return BoxWithMaxWidth(
      maxWidth: 1000,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const H1("Mengubah data Obat"),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Obat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _dosisController,
                      decoration: const InputDecoration(
                        labelText: 'Dosis',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _bentukSediaanController,
                      decoration: const InputDecoration(
                        labelText: 'Bentuk Sediaan',
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
    final dosis = _dosisController.text;
    final bentukSediaan = _bentukSediaanController.text;
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
            "Sedang memasukkan data obat",
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        );
      },
    );

    bool success = await editObat(name, dosis, bentukSediaan, harga, file, id);

    // Close the loading dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Berhasil mengubah data obat"),
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
            content: const Text("Gagal memasukkan data obat"),
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
