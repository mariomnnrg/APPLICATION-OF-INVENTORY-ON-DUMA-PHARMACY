import 'package:aplikasi/functions/barang/list.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/laporan/barang.dart';
import 'package:aplikasi/functions/laporan/obat.dart';
import 'package:aplikasi/functions/obat/laporan/printBarang.dart';
import 'package:aplikasi/functions/obat/list.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});

  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  @override
  Widget build(BuildContext context) {
    print("Building ObatView"); // Debugging print statement
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const H1('Barang'),
            IconButton(
                onPressed: () async {
                  await printReportBarang(context);
                },
                icon: const Icon(Icons.print))
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 30),
        const H2('Selayang Pandang'),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FutureBuilder(
              future: ListBarang(),
              builder: (BuildContext ctx, AsyncSnapshot<List<Barang>?> snpsht) {
                if (snpsht.connectionState == ConnectionState.done &&
                    snpsht.data != null) {
                  int jumlahStokSkrg = 0;
                  snpsht.data!.forEach(
                      (x) => {jumlahStokSkrg = jumlahStokSkrg + x.jumlahStok!});
                  return summaryItem("Total Stok", "${jumlahStokSkrg}");
                } else {
                  return summaryItem("title", "info");
                }
              }),
          FutureBuilder(
              future: fetchLaporanMasukStokBarang(),
              builder: (BuildContext ctx,
                  AsyncSnapshot<List<StokMasukBarang>?> snpsht) {
                if (snpsht.connectionState == ConnectionState.done &&
                    snpsht.data != null) {
                  int jumlahStokSkrg = 0;
                  snpsht.data!.forEach(
                      (x) => jumlahStokSkrg = jumlahStokSkrg + x.stokMasuk!);
                  return summaryItem("Stok Masuk", "$jumlahStokSkrg");
                } else {
                  return summaryItem("title", "info");
                }
              }),
          FutureBuilder(
              future: fetchLaporanKeluarStokBarang(),
              builder: (BuildContext ctx,
                  AsyncSnapshot<List<StokKeluarBarang>?> snpsht) {
                if (snpsht.connectionState == ConnectionState.done &&
                    snpsht.data != null) {
                  int jumlahStokSkrg = 0;
                  snpsht.data!.forEach(
                      (x) => jumlahStokSkrg = jumlahStokSkrg + x.stokKeluar!);
                  return summaryItem("Stok Keluar", "$jumlahStokSkrg");
                } else {
                  return summaryItem("title", "info");
                }
              }),
        ]),
        const SizedBox(height: 40),
        TableStokObatMasuk(),
        const SizedBox(height: 40),
        TableStokObatKeluar(),
      ],
    );
  }
}

Widget summaryItem(String title, String info) {
  return Expanded(
      child: Card(
    margin: const EdgeInsets.all(10),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            H3(title),
            Text(
              info,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            )
          ],
        )),
  ));
}

Widget TableStokObatKeluar() {
  return FutureBuilder(
      future: fetchLaporanKeluarStokObat(),
      builder: (BuildContext ctx, AsyncSnapshot<List<StokKeluarObat>?> snpsht) {
        switch (snpsht.connectionState) {
          case ConnectionState.waiting:
            {
              return const Center(child: CircularProgressIndicator());
            }

          case ConnectionState.done:
            {
              if (snpsht.data != null) {
                DateFormat df = DateFormat("dd MMMM yyyy");

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const H2('Stok Keluar'),
                      const H1('Obat'),
                      // PDFTemplateBarang
                      const SizedBox(height: 10),
                      DataTable(
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Item Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                            DataColumn(
                                label: Text(
                              'Tanggal Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                            DataColumn(
                                label: Text(
                              'Jumlah Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                          ],
                          rows: snpsht.data!.map((x) {
                            return DataRow(cells: [
                              DataCell(Text("${x.obat!.namaObat}")),
                              DataCell(Text("${df.format(x.createdAt!)}")),
                              DataCell(Text("${x.stokKeluar}")),
                            ]);
                          }).toList())
                    ]);
              } else {
                return const Center(
                  child: Text("Mohon periksa koneksi internet anda"),
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
      });
}

Widget TableStokObatMasuk() {
  return FutureBuilder(
      future: fetchLaporanMasukStokObat(),
      builder: (BuildContext ctx, AsyncSnapshot<List<StokMasukObat>?> snpsht) {
        switch (snpsht.connectionState) {
          case ConnectionState.waiting:
            {
              return const Center(child: CircularProgressIndicator());
            }

          case ConnectionState.done:
            {
              if (snpsht.data != null) {
                DateFormat df = DateFormat("dd MMMM yyyy");

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const H2('Stok Masuk'),
                      const SizedBox(height: 10),
                      DataTable(
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Item Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                            DataColumn(
                                label: Text(
                              'Tanggal Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                            DataColumn(
                                label: Text(
                              'Jumlah Masuk',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            )),
                          ],
                          rows: snpsht.data!.map((x) {
                            return DataRow(cells: [
                              DataCell(Text("${x.obat!.namaObat}")),
                              DataCell(Text("${df.format(x.createdAt!)}")),
                              DataCell(Text("${x.stokMasuk}")),
                            ]);
                          }).toList())
                    ]);
              } else {
                return const Center(
                  child: Text("Mohon periksa koneksi internet anda"),
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
      });
}
