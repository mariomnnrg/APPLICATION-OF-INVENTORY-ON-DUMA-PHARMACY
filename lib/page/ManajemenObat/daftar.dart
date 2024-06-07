import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/obat/delete.dart';
import 'package:aplikasi/functions/obat/list.dart';
import 'package:aplikasi/page/ManajemenObat/create.dart';
import 'package:aplikasi/page/ManajemenObat/edit.dart';
import 'package:aplikasi/page/ManajemenObat/ubahStok.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagementListObat extends StatefulWidget {
  const ManagementListObat({super.key});

  @override
  State<ManagementListObat> createState() => _ManagementListObatState();
}

class _ManagementListObatState extends State<ManagementListObat> {
  final searchTerm = TextEditingController();
  var searchedListObat = List<Obat>.empty();
  var dataObat = List<Obat>.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ListObat(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Obat>?> snp) {
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

  Widget _body(List<Obat> dataObat) {
    int totalStok = (dataObat.length > 0)
        ? dataObat
            .map((x) => x.jumlahStok!)
            .reduce((value, element) => value + element)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const H1('Daftar Obat'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const ManagementCreateObat()))
                  .then((msg) {
                if (msg == "reload pls") {
                  setState(() {});
                }
              });
            },
            child: const Text('Tambah Obat'),
          ),
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          summaryItem("Jumlah Jenis Obat", "${dataObat.length}"),
          summaryItem("Jumlah Obat", "$totalStok"),
        ]),
        const SizedBox(height: 40),
        const H2('Tabel Data'),
        const SizedBox(height: 10),
        if (MediaQuery.of(context).size.width > 600) ...{
          TableStokObat(dataObat),
        } else ...{
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TableStokObat(dataObat),
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

  Widget TableStokObat(List<Obat> dataObat) {
    var sW = MediaQuery.of(context).size.width;
    var dF = DateFormat("dd MMMM yyyy");

    return Container(
      width: sW * 0.05,
      child: Padding(
          padding: EdgeInsets.only(top: 10),
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
                          labelText: 'Cari barang obat disni',
                          border: OutlineInputBorder(),
                        ),
                        controller: searchTerm,
                      )),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.search),
                      )
                    ]),
                  )),
              const SizedBox(height: 20),
              Column(
                  children: dataObat
                      .where((t) {
                        return t.namaObat!.contains(searchTerm.text);
                      })
                      .map((x) => SingleChildScrollView(
                            child: Card(
                              margin: EdgeInsets.only(
                                  bottom: 20, left: 30, right: 30),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      width: sW * 0.15,
                                      height: sW * 0.25,
                                      child: Image.network(
                                        x.gambar!,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: H2(
                                                x.namaObat!,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "ditambahkan pada ${dF.format(x.createdAt!)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: List.generate(
                                                    x.kategoriObat == null
                                                        ? 0
                                                        : x.kategoriObat!
                                                            .length,
                                                    (ii) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Badge(
                                                          label: Text(
                                                            x.kategoriObat![ii]
                                                                .namaKategoriObat!,
                                                          ),
                                                          backgroundColor:
                                                              Colors.blue
                                                                  .shade400,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(children: [
                                              info("Jumlah Stok",
                                                  "${x.jumlahStok!}"),
                                              const SizedBox(width: 10),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              ubahStokObatView(
                                                                  id: x.id!)))
                                                      .then((x) {
                                                    if (x == "boombaclat") {
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors
                                                              .amber.shade900),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                ),
                                                child: const Text("ubah Stok"),
                                              ),
                                            ]),
                                            info("Bentuk Sediaan",
                                                "${x.bentukSediaan!}"),
                                            info("Dosis", "${x.dosisObat!}"),
                                            info("Harga",
                                                "Rp ${x.hargaSediaan!}"),
                                            SizedBox(height: 20),
                                            Actions(context, x.id!),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList()),
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
                  builder: (context) => ManagementEditObat(
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
            'Apakah Anda yakin ingin menghapus obat ini?',
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
                DeleteObat(id).then((res) {
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
