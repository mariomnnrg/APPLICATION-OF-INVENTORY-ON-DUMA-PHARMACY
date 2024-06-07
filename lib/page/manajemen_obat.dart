import 'package:aplikasi/page/ManajemenObat/daftar.dart';
import 'package:aplikasi/page/ManajemenObat/daftarKategori.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:flutter/material.dart';

class ManajemenObat extends StatefulWidget {
  const ManajemenObat({super.key});

  @override
  State<ManajemenObat> createState() => _ManajemenObatState();
}

class _ManajemenObatState extends State<ManajemenObat> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const Sidebar(),
          appBar: TopBar(context,
              title: 'Manajemen Obat',
              tabBar: const TabBar(
                tabs: [
                  Tab(text: 'Obat'),
                  Tab(text: 'Kategori'),
                ],
              )),
          body: const TabBarView(
            children: [
              BoxWithMaxWidth(maxWidth: 1000, child: ManagementListObat()),
              BoxWithMaxWidth(
                  maxWidth: 1000,
                  child: ManagementListKategoriObat())
            ],
          ),
        ));
  }

  Widget PerView(Widget child) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: child,
      ),
    );
  }
}
