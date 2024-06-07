import 'package:flutter/material.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:aplikasi/page/ManajemenObat/createKategori.dart';

class ManagementListKategoriObat extends StatefulWidget {
  const ManagementListKategoriObat({super.key});

  @override
  State<ManagementListKategoriObat> createState() =>
      _ManagementListKategoriObatState();
}

class _ManagementListKategoriObatState
    extends State<ManagementListKategoriObat> {
  final List<Map<String, String>> _categories = [
    {'nama': 'Kategori 1', 'jumlah': '100'},
    {'nama': 'Kategori 2', 'jumlah': '200'},
    // Add more categories here
  ];

  void _showDeleteConfirmationDialog(int index) {
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
            'Confirm Deletion',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Are you sure you want to delete this category?',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const H1('Daftar Kategori Obat'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ManagementCreateKategori()));
            },
            child: const Text('Tambah Kategori Obat'),
          ),
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          summaryItem("Jumlah Kategori", _categories.length.toString()),
        ]),
        const SizedBox(height: 40),
        const H2('Tabel Data'),
        const SizedBox(height: 10),
        TableStokObat()
      ],
    );
  }

  Widget summaryItem(String title, String info) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
              children: [
                H3(title),
                Text(
                  info,
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.w900),
                )
              ],
            )));
  }

  Widget TableStokObat() {
    return DataTable(
      columns: const [
        DataColumn(
            label: Text(
          'Nama Kategori',
          style: TextStyle(fontWeight: FontWeight.w900),
        )),
        DataColumn(
            label: Text(
          'Jumlah',
          style: TextStyle(fontWeight: FontWeight.w900),
        )),
        DataColumn(
            label: Text(
          'Actions',
          style: TextStyle(fontWeight: FontWeight.w900),
        )),
      ],
      rows: _categories.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> category = entry.value;
        return DataRow(cells: [
          DataCell(Text(category['nama']!)),
          DataCell(Text(category['jumlah']!)),
          DataCell(Actions(index)),
        ]);
      }).toList(),
    );
  }

  Widget Actions(int index) {
    return Row(children: [
      ElevatedButton(
        onPressed: () {
          _showDeleteConfirmationDialog(index);
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.red[900])),
        child: Text("Delete", style: TextStyle(color: Colors.red.shade50)),
      ),
    ]);
  }
}
