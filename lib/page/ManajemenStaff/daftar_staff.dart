import 'package:aplikasi/functions/auth/staff/delete.dart';
import 'package:aplikasi/functions/auth/staff/list.dart';
import 'package:aplikasi/functions/data/models/user.dart';
import 'package:aplikasi/page/ManajemenStaff/update_staff.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:flutter/material.dart';

class DaftarStaff extends StatefulWidget {
  const DaftarStaff({super.key});

  @override
  State<DaftarStaff> createState() => _DaftarStaffState();
}

class _DaftarStaffState extends State<DaftarStaff> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetListStaff(),
        builder: (BuildContext ctx, AsyncSnapshot<List<User>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }

            case ConnectionState.done:
              {
                if (snapshot.hasError || snapshot.data == null) {
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
                              const H1('Daftar Staff'),
                            ]),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              summaryItem(
                                  "Jumlah Staff", "${snapshot.data!.length}"),
                            ]),
                        const SizedBox(height: 40),
                        const H2('Tabel Data'),
                        const SizedBox(height: 10),
                        TableStokBarang(snapshot.data!)
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

  Widget TableStokBarang(List<User> data) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            'Nama Staff',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        DataColumn(
          label: Text(
            'Email',
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
                  DataCell(Text("${entry.value.name}")),
                  DataCell(Text("${entry.value.email}")),
                  DataCell(Actions(entry.value.id!)),
                ],
              ))
          .toList(),
    );
  }

  Widget Actions(int id) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => UpdateStaff(id: id)))
                .then((request) {
              if (request == "pls reload") {
                setState(() {});
              }
            });
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.amber[900]),
          ),
          child: Text("Edit", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
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
            'Apakah Anda yakin ingin menghapus akun ini?',
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
              onPressed: () async {
                if (await DeleteAkunStaff(id)) {
                  Navigator.of(context).pop();
                  setState(() {});
                } else {
                  Navigator.of(context).pop();
                  _showSomething(context, "Gagal menghapus",
                      "Mohon periksa koneksi internet anda");
                }
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

  void _showSomething(BuildContext ctx, String message, String submessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
          title: Text(message),
          content: Text(submessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
