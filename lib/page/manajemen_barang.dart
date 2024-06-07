import 'package:aplikasi/page/ManajemenBarang/daftar.dart';
import 'package:aplikasi/page/ManajemenBarang/daftarKategori.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:flutter/material.dart';

class ManagementBarang extends StatefulWidget {
  const ManagementBarang({super.key});

  @override
  State<ManagementBarang> createState() => _ManagementBarangState();
}

class _ManagementBarangState extends State<ManagementBarang> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const Sidebar(),
          appBar: TopBar(context,
              title: 'Manajemen Barang',
              tabBar: const TabBar(
                tabs: [
                  Tab(text: 'Barang'),
                  Tab(text: 'Kategori'),
                ],
              )),
          body: const TabBarView(
            children: [
              BoxWithMaxWidth(maxWidth: 1000, child: ManagementListBarang()),
              BoxWithMaxWidth(
                  maxWidth: 1000,
                  child: ManagementListKategoriBarang())
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
