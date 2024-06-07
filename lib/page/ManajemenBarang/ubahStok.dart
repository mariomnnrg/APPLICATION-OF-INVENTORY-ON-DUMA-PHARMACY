import 'package:aplikasi/functions/barang/stok.dart';
import 'package:aplikasi/functions/obat/stok.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component/constrainedbox.dart';
import '../component/sidebar.dart';
import '../component/titles.dart';
import '../component/topbar.dart';

class ubahStokBarangView extends StatefulWidget {
  final int id;
  const ubahStokBarangView({super.key, required this.id});

  @override
  State<ubahStokBarangView> createState() => _ubahStokBarangViewState(id: id);
}

class _ubahStokBarangViewState extends State<ubahStokBarangView> {
  final TextEditingController _jumlahStokController = TextEditingController();
  final TextEditingController _expiredDateController = TextEditingController();
  final int id;

  _ubahStokBarangViewState({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: TopBar(context, title: "Mengubah jumlah stok"),
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
                  const H1("Mengubah jumlah stok"),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        TextField(
                          controller: _jumlahStokController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Jumlah tambah/kurang',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _expiredDateController,
                          decoration: InputDecoration(
                            labelText: 'Tanggal expired (untuk stok masuk)',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                await _add();
                              },
                              child: const Text('Tambah'),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                await _reduce();
                              },
                              child: const Text('Kurang'),
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

  Future<void> _reduce() async {
    var result =
        await kurangiStokBarang(this.id, int.parse(_jumlahStokController.text));

    switch (result) {
      case 1:
        Navigator.of(context).pop("boombaclat");
        break;
      case 3:
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: const Text(
                  "Anda tidak bisa memasukkan lebih dari apa yang ada"),
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
        break;
      default:
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: const Text("Gagal mengurangi stok obat"),
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
        break;
    }
  }

  Future<void> _add() async {
    if (_expiredDateController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text("Mohon untuk memilih tanggal"),
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
    } else {
      var result = await tambahStokBarang(
          this.id,
          int.parse(_jumlahStokController.text),
          DateFormat("MM/dd/yyyy").parse(_expiredDateController.text));

      if (result) {
        Navigator.of(context).pop("boombaclat");
      } else {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: const Text("Gagal menambahkan stok obat"),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _expiredDateController.text = DateFormat("MM/dd/yyyy").format(picked);
      });
    }
  }
}
