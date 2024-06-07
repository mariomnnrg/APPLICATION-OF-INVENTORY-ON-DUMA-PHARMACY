import 'dart:io';

import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/obat/create.dart';
import 'package:aplikasi/functions/obat/kategori/list.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagementCreateObat extends StatefulWidget {
  const ManagementCreateObat({super.key});

  @override
  State<ManagementCreateObat> createState() => _ManagementCreateObatState();
}

class _ManagementCreateObatState extends State<ManagementCreateObat> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _bentukSediaanController =
      TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
//  final TextEditingController _expiredController = TextEditingController();

  String? _selectedFileName;
  PlatformFile? _selectedFile;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       _expiredController.text = DateFormat("MM/dd/yyyy").format(picked);
  //     });
  //   }
  // }

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

  int categoryN = 1;
  List<int?> selectedCategoryIds = [null];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: TopBar(context, title: "Tambahkan sebuah Obat"),
      body: Center(
        child: FutureBuilder(
          future: ListKategoriObat(),
          builder: (BuildContext ctx, AsyncSnapshot<List<KategoriObat>?> snp) {
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

  Widget _view(BuildContext ctx, List<KategoriObat> dko) {
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
              const H1("Tambahkan Obat"),
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
                      controller: _jumlahController,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
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
                    // const SizedBox(height: 16.0),
                    // TextField(
                    //   controller: _expiredController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Tanggal',
                    //     border: const OutlineInputBorder(),
                    //     suffixIcon: IconButton(
                    //       icon: const Icon(Icons.calendar_today),
                    //       onPressed: () => _selectDate(context),
                    //     ),
                    //   ),
                    //   readOnly: true,
                    // ),
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
                    Column(
                      children: List.generate(categoryN, (n) {
                        return Column(
                          children: [
                            DropdownButtonFormField<int>(
                              value: selectedCategoryIds[n],
                              decoration: InputDecoration(
                                labelText: "Kategori ${n + 1}",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                              ),
                              items: dko.map((KategoriObat ko) {
                                return DropdownMenuItem<int>(
                                  value: ko.id,
                                  child: Text("${ko.namaKategoriObat}"),
                                );
                              }).toList(),
                              onChanged: (int? nv) {
                                setState(() {
                                  selectedCategoryIds[n] = nv;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _reduceCategory(context);
                            });
                          },
                          child: Text(
                            "Kurangi Kategori",
                            style: TextStyle(color: Colors.red.shade50),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade500,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              categoryN++;
                              selectedCategoryIds.add(null);
                            });
                          },
                          child: Text(
                            "Tambah Kategori",
                            style: TextStyle(color: Colors.green.shade50),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade500,
                          ),
                        ),
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

  void _reduceCategory(BuildContext ctx) {
    if (categoryN > 1) {
      setState(() {
        categoryN--;
        selectedCategoryIds.removeLast();
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Anda harus memilih minimal satu kategori"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            actions: [
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

  Future<void> _inputData() async {
    final name = _nameController.text;
    final jumlah = _jumlahController.text;
    final dosis = _dosisController.text;
    final bentukSediaan = _bentukSediaanController.text;
    final harga = _hargaController.text;

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

    double hargaC = 0;
    try {
      hargaC = double.parse(harga);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Harga harus berupa angka"),
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

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          content: Text(
            "Sedang memasukkan data obat",
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        );
      },
    );

    bool success = await createObatData(
      name,
      int.parse(jumlah),
      dosis,
      bentukSediaan,
      hargaC,
      selectedCategoryIds,
      file,
    );

    // Close the loading dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Berhasil memasukkan data obat"),
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
