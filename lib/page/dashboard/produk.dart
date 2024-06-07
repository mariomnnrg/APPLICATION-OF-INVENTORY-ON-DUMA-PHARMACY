import 'package:aplikasi/functions/barang/kategori/list.dart';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/obat/kategori/list.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../functions/data/models/obat.dart';

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
        const H1('Data Stok'),
        const Text(
          'per kategori',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Divider(),
        const SizedBox(height: 20),
        const H2('Grafik'),
        const SizedBox(height: 20),
        Pie(),
        const SizedBox(height: 50),
        const Divider(),
        const SizedBox(height: 20),
        const H2('Detail Data'),
        const SizedBox(height: 20),
        TableStokObat()
      ],
    );
  }

  int Counter(KategoriBarang data) {
    int c = 0;
    if (data.barang != null) {
      data.barang!.forEach((x) {
        c += x!.jumlahStok!;
      });
    }

    return c;
  }

  Widget Pie() {
    return FutureBuilder(
        future: ListKategoriBarang(),
        builder: (BuildContext ctx, AsyncSnapshot<List<KategoriBarang>?> snp) {
          if (snp.connectionState == ConnectionState.done && snp.data != null) {
            return LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                  height: 500,
                  child: PieChart(PieChartData(
                    pieTouchData: PieTouchData(),
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    sections: snp.data!.map((x) {
                      return PieChartSectionData(
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.5),
                          value: (Counter(x)).toDouble(),
                          title:
                              '${x.namaKategoriBarang}\n[${Counter(x)} produk]',
                          radius: 250, // Reduced radius for better rendering
                          titleStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold));
                    }).toList(),
                  )));
            });
          } else {
            return const Center(child: Text("Loading Graph, mohon sebentar"));
          }
        });
  }

  List<PieChartSectionData> showSectionChartOne() {
    return [
      PieChartSectionData(
          color: Colors.green.shade100,
          value: 30,
          title: 'kategori 1\n[30 obat]',
          radius: 250, // Reduced radius for better rendering
          titleStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ];
  }

  Widget TableStokObat() {
    return FutureBuilder(
        future: ListKategoriBarang(),
        builder: (BuildContext ctx, AsyncSnapshot<List<KategoriBarang>?> snp) {
          if (snp.connectionState == ConnectionState.done && snp.data != null) {
            return DataTable(
              columns: const [
                DataColumn(
                    label: Text(
                  'Nama Kategori',
                  style: TextStyle(fontWeight: FontWeight.w900),
                )),
                DataColumn(
                    label: Text(
                  'Stok',
                  style: TextStyle(fontWeight: FontWeight.w900),
                )),
                DataColumn(
                    label: Text(
                  'Jumlah Produk',
                  style: TextStyle(fontWeight: FontWeight.w900),
                )),
              ],
              rows: snp.data!
                  .map((item) => DataRow(cells: [
                        DataCell(Text('${item.namaKategoriBarang}')),
                        DataCell(Text('${Counter(item)}')),
                        DataCell(Text('Rp 10.000')),
                      ]))
                  .toList(),
            );
          } else {
            return const Center(child: Text("Loading Graph, mohon sebentar"));
          }
        });
  }
}
