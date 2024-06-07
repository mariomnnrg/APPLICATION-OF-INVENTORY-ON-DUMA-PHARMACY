import 'dart:io';
import 'package:aplikasi/functions/data/models/barang.dart';
import 'package:aplikasi/functions/data/models/obat.dart';
import 'package:aplikasi/functions/laporan/barang.dart';
import 'package:aplikasi/functions/obat/list.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget PDFTemplateBarang(List<StokMasukBarang>? obatMasuk,
    List<StokKeluarBarang>? obatKeluar, List<Obat>? stok) {
  if (obatMasuk != null && obatKeluar != null && stok != null) {
    DateFormat dtf = DateFormat("dd MMMM yyyy");

    var totalStok = 0;
    stok!.forEach((x) {
      totalStok += x.jumlahStok!;
    });

    var totalMasuk = 0;
    obatMasuk.forEach((x) {
      totalMasuk += x.stokMasuk!;
    });

    var totalKeluar = 0;
    obatKeluar.forEach((x) {
      totalKeluar += x.stokKeluar!;
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text('Laporan Barang'),
        pw.SizedBox(height: 10),
        pw.Text('Selayang Pandang', style: const pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            summaryItem("Total Stok", "${totalStok}"),
            summaryItem("Stok Obat Masuk", "${totalMasuk}"),
            summaryItem("Stok Obat Keluar", "${totalKeluar}"),
          ],
        ),
        pw.Text('Tabel Data Masuk', style: const pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 10),
        // Add the table here
        pw.Table.fromTextArray(
          headers: ['Item Masuk', 'Tanggal Masuk', 'Jumlah Masuk'],
          data: obatMasuk!.map((el) {
            return [
              '${el.barang!.namaBarang}',
              '${dtf.format(el.createdAt!)}',
              '${el.stokMasuk}'
            ];
          }).toList(),
          headerStyle:
              pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(fontSize: 10),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(width: 0.5, color: PdfColors.grey),
          ),
          cellHeight: 20,
        ),
        pw.SizedBox(height: 20),
        pw.Text('Tabel Data Keluar', style: const pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Item Masuk', 'Tanggal Masuk', 'Jumlah Masuk'],
          data: obatKeluar!.map((el) {
            return [
              '${el.barang!.namaBarang}',
              '${dtf.format(el.createdAt!)}',
              '${el.stokKeluar}'
            ];
          }).toList(),
          headerStyle:
              pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(fontSize: 10),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(width: 0.5, color: PdfColors.grey),
          ),
          cellHeight: 20,
        ),
      ],
    );
  } else {
    return pw.Center(child: pw.Text("Silahkan ulangi kembali"));
  }
}

Future<void> printReportBarang(BuildContext context) async {
  DateFormat dtf = DateFormat("dd MMMM yyyy");

  final pdf = pw.Document();
  final stokBarangMasuk = await fetchLaporanMasukStokBarang();
  final stokBarangKeluar = await fetchLaporanKeluarStokBarang();
  final daftarStok = await ListObat();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          PDFTemplateBarang(stokBarangMasuk, stokBarangKeluar, daftarStok)
        ];
      },
    ),
  );

  final directory = await getDownloadsDirectory();
  final storedDirectory = await FilesystemPicker.open(
      context: context,
      rootDirectory: directory!,
      title: 'Select where to save',
      fsType: FilesystemType.folder,
      pickText:
          'Simpan dokumen disini sebagai laporan_dokumen_barang (${dtf.format(DateTime.now())}).pdf');

  if (storedDirectory != null) {
    final file = File(
        "${storedDirectory}/laporan_dokumen_barang (${dtf.format(DateTime.now())}).pdf");
    await file.writeAsBytes(await pdf.save());
  }
}

pw.Widget summaryItem(String title, String info) {
  return pw.Expanded(
    child: pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        children: [
          pw.Text(title,
              style: const pw.TextStyle(fontSize: 18),
              textAlign: pw.TextAlign.center),
          pw.Text(info,
              style:
                  pw.TextStyle(fontSize: 48, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    ),
  );
}
