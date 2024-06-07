import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/topbar.dart';
import 'package:aplikasi/page/laporan/obat.dart';
import 'package:aplikasi/page/laporan/produk.dart';
import 'package:aplikasi/page/component/sidebar.dart';
import 'package:flutter/material.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const Sidebar(),
          appBar: TopBar(context,
              title: 'Laporan',
              tabBar: const TabBar(
                tabs: [
                  Tab(text: 'Obat'),
                  Tab(text: 'Produk'),
                ],
              )),
          body: const TabBarView(
            children: [
              BoxWithMaxWidth(maxWidth: 1000, child: ObatView()),
              BoxWithMaxWidth(maxWidth: 1000, child: ProdukView())
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
