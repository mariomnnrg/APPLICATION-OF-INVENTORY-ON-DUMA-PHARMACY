import 'package:intl/intl.dart';

class KategoriObat {
  int? id;
  String? namaKategoriObat;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Obat>? obat;

  KategoriObat({
    this.id,
    this.namaKategoriObat,
    this.createdAt,
    this.updatedAt,
    this.obat,
  });

  factory KategoriObat.fromJson(Map<String, dynamic> json) {
    var obatFromJson = json['obat'] as List?;
    List<Obat>? obatList = obatFromJson?.map((i) => Obat.fromJson(i)).toList();

    var dateFormat = DateFormat("dd/MM/yyyy");

    return KategoriObat(
      id: json['id'],
      namaKategoriObat: json['nama_kategori_obat'],
      createdAt: dateFormat.parse(json['created_at']),
      updatedAt: dateFormat.parse(json['updated_at']),
      obat: obatList,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return {
      'id': id,
      'nama_kategori_obat': namaKategoriObat,
      'created_at': createdAt == null ? null : dateFormat.format(createdAt!),
      'updated_at': createdAt == null ? null : dateFormat.format(updatedAt!),
      'obat': obat?.map((obat) => obat.toJson()).toList(),
    };
  }
}

class Obat {
  int? id;
  String? namaObat;
  int? jumlahStok;
  String? dosisObat;
  String? bentukSediaan;
  double? hargaSediaan; // Changed Float to double
  String? gambar;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<KategoriObat>? kategoriObat;

  Obat({
    this.id,
    this.namaObat,
    this.jumlahStok,
    this.dosisObat,
    this.bentukSediaan,
    this.hargaSediaan,
    this.gambar,
    this.createdAt,
    this.updatedAt,
    this.kategoriObat,
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    var dateFormat = DateFormat("dd/MM/yyyy");

    var kategoriObatFromJson = json['kategori'] as List?;
    List<KategoriObat>? kategoriObatList =
        kategoriObatFromJson?.map((i) => KategoriObat.fromJson(i)).toList();

    return Obat(
      id: json['id'],
      namaObat: json['nama_obat'],
      jumlahStok: json['jumlah_stok'],
      dosisObat: json['dosis_obat'],
      bentukSediaan: json['bentuk_sediaan'],
      hargaSediaan: json['harga'].toDouble(),
      gambar: json['gambar'],
      createdAt: dateFormat.parse(json['created_at']),
      updatedAt: dateFormat.parse(json['updated_at']),
      kategoriObat: kategoriObatList,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return {
      'id': id,
      'nama_obat': namaObat,
      'jumlah_stok': jumlahStok,
      'dosis_obat': dosisObat,
      'bentuk_sediaan': bentukSediaan,
      'harga': hargaSediaan,
      'gambar': gambar,
      'created_at': createdAt == null ? null : dateFormat.format(createdAt!),
      'updated_at': updatedAt == null ? null : dateFormat.format(updatedAt!),
      'kategori': kategoriObat?.map((kobat) => kobat.toJson()).toList(),
    };
  }
}

class StokObatAddReq {
  final int? obatId;
  final int? amount;
  final DateTime? expiredDate;

  StokObatAddReq({this.obatId, this.amount, this.expiredDate});

  factory StokObatAddReq.fromJson(Map<String, dynamic> json) {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return StokObatAddReq(
        obatId: json["obat_id"],
        amount: json["amount"],
        expiredDate: dateFormat.parse(json["expired_date"]));
  }

  Map<String, dynamic> toJson() {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return {
      "obat_id": obatId,
      "amount": amount,
      "expired_date":
          expiredDate == null ? null : dateFormat.format(expiredDate!)
    };
  }
}

class StokObatRedReq {
  final int? obatId;
  final int? amount;

  StokObatRedReq({this.obatId, this.amount});

  factory StokObatRedReq.fromJson(Map<String, dynamic> json) {
    return StokObatRedReq(
      obatId: json["obat_id"],
      amount: json["amount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "obat_id": obatId,
      "amount": amount,
    };
  }
}

class StokMasukObat {
  final int? id;
  final int? obatId;
  final int? stokMasuk;
  final DateTime? expiredDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Obat? obat;

  StokMasukObat({
    this.id,
    this.obatId,
    this.stokMasuk,
    this.expiredDate,
    this.createdAt,
    this.updatedAt,
    this.obat,
  });

  factory StokMasukObat.fromJson(Map<String, dynamic> json) {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return StokMasukObat(
      id: json["id"],
      obatId: json["obat_id"],
      stokMasuk: json["stok_masuk"],
      expiredDate: dateFormat.parse(json["expired_date"]),
      createdAt: dateFormat.parse(json["created_at"]),
      updatedAt: dateFormat.parse(json["updated_at"]),
      obat: json['obat'] != null ? Obat.fromJson(json['obat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return {
      "id": id,
      "obat_id": obatId,
      "stok_masuk": stokMasuk,
      "expired_date":
          expiredDate == null ? null : dateFormat.format(expiredDate!),
      "created_at": createdAt == null ? null : dateFormat.format(createdAt!),
      "updated_at": updatedAt == null ? null : dateFormat.format(updatedAt!),
      "obat": obat?.toJson(),
    };
  }
}

class StokKeluarObat {
  final int? id;
  final int? obatId;
  final int? stokKeluar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Obat? obat;

  StokKeluarObat({
    this.id,
    this.obatId,
    this.stokKeluar,
    this.createdAt,
    this.updatedAt,
    this.obat,
  });

  factory StokKeluarObat.fromJson(Map<String, dynamic> json) {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return StokKeluarObat(
      id: json["id"],
      obatId: json["obat_id"],
      stokKeluar: json["stok_keluar"],
      createdAt: dateFormat.parse(json["created_at"]),
      updatedAt: dateFormat.parse(json["updated_at"]),
      obat: json['obat'] != null ? Obat.fromJson(json['obat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormat = DateFormat("dd/MM/yyyy");

    return {
      "id": id,
      "obat_id": obatId,
      "stok_keluar": stokKeluar,
      "created_at": createdAt == null ? null : dateFormat.format(createdAt!),
      "updated_at": updatedAt == null ? null : dateFormat.format(updatedAt!),
      "obat": obat?.toJson(),
    };
  }
}
