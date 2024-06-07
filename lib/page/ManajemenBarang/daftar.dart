import 'package:aplikasi/functions/barang/delete.dart';
import 'package:aplikasi/functions/barang/list.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/page/ManajemenBarang/create.dart';
import 'package:aplikasi/page/ManajemenBarang/edit.dart';
import 'package:aplikasi/page/ManajemenBarang/ubahStok.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagementListBarang extends StatefulWidget {
  const ManagementListBarang({super.key});

  @override
  State<ManagementListBarang> createState() => _ManagementListBarangState();
}

class _ManagementListBarangState extends State<ManagementListBarang> {
  final searchTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ListBarang(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Barang>?> snp) {
          switch (snp.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.done:
              {
                if (snp.data == null) {
                  return const Center(
                      child: Text("Mohon periksa koneksi internet anda"));
                } else {
                  return _body(snp.data!);
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

  Widget _body(List<Barang> databarang) {
    int totalStok = (databarang.isNotEmpty)
        ? databarang
            .map((x) => x.jumlahStok!)
            .reduce((value, element) => value + element)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const H1('Daftar Barang'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const ManagementCreateBarang()))
                  .then((msg) {
                if (msg == "reload pls") {
                  setState(() {});
                }
              });
            },
            child: const Text('Tambah Barang'),
          ),
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          summaryItem("Jumlah Jenis barang", "${databarang.length}"),
          summaryItem("Jumlah barang", "$totalStok"),
        ]),
        const SizedBox(height: 40),
        const H2('Tabel Data'),
        const SizedBox(height: 10),
        if (MediaQuery.of(context).size.width > 600) ...{
          TableStokbarang(databarang),
        } else ...{
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TableStokbarang(databarang),
          ),
        },
      ],
    );
  }

  Widget summaryItem(String title, String info) {
    return Expanded(
        child: Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              H3(title),
              Text(
                info,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
              )
            ],
          )),
    ));
  }

  Widget TableStokbarang(List<Barang> dataBarang) {
    var sW = MediaQuery.of(context).size.width;
    var dF = DateFormat("dd MMMM yyyy");

    return Container(
      width: sW * 0.05,
      child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                  child: Expanded(
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Cari barang barang disni',
                          border: OutlineInputBorder(),
                        ),
                        controller: searchTerm,
                      )),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.search),
                      )
                    ]),
                  )),
              Column(
                children: dataBarang.where((x) {
                  return x.namaBarang!.contains(searchTerm.text);
                }).map((data) {
                  return SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              width: sW * 0.15,
                              height: sW * 0.25,
                              child: Image.network(
                                data.gambar!,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: H2(
                                        data.namaBarang!,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ditambahkan pada ${dF.format(data.createdAt!)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: List.generate(
                                            data.kategoriBarang == null
                                                ? 0
                                                : data.kategoriBarang!.length,
                                            (ii) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: Badge(
                                                  label: Text(
                                                    data.kategoriBarang![ii]
                                                        .namaKategoriBarang!,
                                                  ),
                                                  backgroundColor:
                                                      Colors.blue.shade400,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      info(
                                          "Jumlah Stok", "${data.jumlahStok!}"),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ubahStokBarangView(
                                                          id: data.id!)))
                                              .then((x) {
                                            if (x == "boombaclat") {
                                              setState(() {});
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.amber.shade900),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        child: const Text("ubah Stok"),
                                      ),
                                    ]),
                                    info("Deskripsi", "${data.deskripsi!}"),
                                    info("Harga", "Rp ${data.harga!}"),
                                    SizedBox(height: 20),
                                    Actions(context, data.id!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          )),
    );
  }

  Widget info(String ttl, String info) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ttl,
          ),
          Text(info,
              softWrap: true,
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold))
        ],
      ),
    ));
  }

  Widget Actions(BuildContext context, int id) {
    return Row(children: [
      ElevatedButton(
        onPressed: () {
          _showDeleteConfirmationDialog(id);
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.red[900])),
        child: Text("Delete", style: TextStyle(color: Colors.red.shade50)),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ManagementEditBarang(
                        id: id,
                      )))
              .then((i) {
            if (i == "reload pls") {
              setState(() {});
            }
          });
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.amber[900])),
        child: Text("Edit", style: TextStyle(color: Colors.black)),
      )
    ]);
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
            'Apakah Anda yakin ingin menghapus barang ini?',
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
                DeleteBarang(id).then((res) {
                  if (res) {
                    setState(() {});
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Hapus', style: TextStyle(color: Colors.white)),
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
