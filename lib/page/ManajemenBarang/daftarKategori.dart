import 'package:aplikasi/functions/barang/kategori/delete.dart';
import 'package:aplikasi/functions/barang/kategori/list.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/page/ManajemenBarang/createKategori.dart';
import 'package:aplikasi/page/ManajemenBarang/editKategori.dart';
import 'package:aplikasi/page/ManajemenObat/editKategori.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:intl/intl.dart';

class ManagementListKategoriBarang extends StatefulWidget {
  const ManagementListKategoriBarang({Key? key});

  @override
  State<ManagementListKategoriBarang> createState() =>
      _ManagementListKategoriBarangState();
}

class _ManagementListKategoriBarangState
    extends State<ManagementListKategoriBarang> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ListKategoriBarang(),
        builder:
            (BuildContext ctx, AsyncSnapshot<List<KategoriBarang>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }

            case ConnectionState.done:
              {
                if (snapshot.data == null) {
                  print(snapshot.hasError);
                  return const Center(
                      child: Text("Mohon periksa koneksi internet anda"));
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const H1('Daftar Kategori Barang'),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ManagementCreateKategoriBarang()))
                                      .then((val) {
                                    setState(() {});
                                  });
                                },
                                child: const Text('Tambah Kategori Barang'),
                              ),
                            ]),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              summaryItem("Jumlah Jenis kategori",
                                  snapshot.data!.length.toString()),
                            ]),
                        const SizedBox(height: 40),
                        const H2('Tabel Data'),
                        const SizedBox(height: 10),
                        TableDaftarKategori(snapshot.data!)
                      ]);
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
        });
  }

  Widget summaryItem(String title, String info) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            H3(title),
            Text(
              info,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget TableDaftarKategori(List<KategoriBarang> data) {
    DateFormat format = DateFormat("dd MMMM yyyy");

    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            'Nama Kategori',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        DataColumn(
          label: Text(
            'Tanggal Dibuat',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        DataColumn(
          label: Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
      rows: data
          .asMap()
          .entries
          .map((entry) => DataRow(
                cells: [
                  DataCell(Text(entry.value.namaKategoriBarang!)),
                  DataCell(Text(format.format(entry.value.createdAt!))),
                  DataCell(Actions(entry.value.id!)),
                ],
              ))
          .toList(),
    );
  }

  Widget Actions(int id) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ManagementEditKategoriBarang(id: id)))
                .then((val) {
              if (val == 'do refresh') {
                setState(() {});
              }
            });
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.amber[900]),
          ),
          child: const Text("Edit", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            _showDeleteConfirmationDialog(id);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color?>(Colors.red[900]),
          ),
          child: Text("Hapus", style: TextStyle(color: Colors.red.shade50)),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus kategori ini?',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                DeleteKategoriBarang(id).then((res) {
                  if (res) {
                    setState(() {});
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
