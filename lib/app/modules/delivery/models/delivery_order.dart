import 'dart:convert';

List<ListDo> listDoFromJson(List lst) =>
    List<ListDo>.from(lst.map((x) => ListDo.fromJson(x)));

String listDoToJson(List<ListDo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// VERSI 50: tanggal kosong dari server ('' / null) tidak lagi membuat parsing gagal.
/// Contoh: DO perpindahan barang tidak punya tanggal estimasi sampai / ref date.
DateTime tanggalAman(dynamic value, [DateTime? cadangan]) {
  if (value == null) return cadangan ?? DateTime(1970);
  final s = value.toString().trim();
  if (s.isEmpty || s.startsWith('0000')) return cadangan ?? DateTime(1970);
  return DateTime.tryParse(s) ?? (cadangan ?? DateTime(1970));
}

String teksAman(dynamic value, [String bawaan = '-']) {
  if (value == null) return bawaan;
  final s = value.toString();
  return s.isEmpty ? bawaan : s;
}

/// barang di DO (VERSI 50, dari field items API)
class ItemDo {
  String kodeProduk;
  String namaProduk;
  String keterangan;
  double qty;
  String satuan;
  double qtyKoli;

  ItemDo({
    required this.kodeProduk,
    required this.namaProduk,
    required this.keterangan,
    required this.qty,
    required this.satuan,
    required this.qtyKoli,
  });

  static double _angka(dynamic v) =>
      v is num ? v.toDouble() : (double.tryParse('${v ?? ''}') ?? 0);

  factory ItemDo.fromJson(Map<String, dynamic> json) => ItemDo(
        kodeProduk: teksAman(json['kode_produk'], ''),
        namaProduk: teksAman(json['nama_produk'], ''),
        keterangan: teksAman(json['keterangan'], ''),
        qty: _angka(json['qty']),
        satuan: teksAman(json['satuan'], ''),
        qtyKoli: _angka(json['qty_koli']),
      );

  Map<String, dynamic> toJson() => {
        'kode_produk': kodeProduk,
        'nama_produk': namaProduk,
        'keterangan': keterangan,
        'qty': qty,
        'satuan': satuan,
        'qty_koli': qtyKoli,
      };

  /// 1000 -> "1.000", 2.5 -> "2,5"
  static String format(double v) {
    final bulat = v == v.roundToDouble();
    var s = bulat ? v.toStringAsFixed(0) : v.toString().replaceAll('.', ',');
    if (bulat) {
      s = s.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m.group(1)}.');
    }
    return s;
  }
}

class ListDo {
  String id;
  DateTime tglEstimasiPickup;
  String jamEstimasiPickup;
  DateTime tglEstimasiSampai;
  String jamEstimasiSampai;
  DateTime refDate;
  String noDeliv;
  String shipVia;
  String poNumber;
  String alamatPickup;
  String alamatPengiriman;
  dynamic memo;
  dynamic status;
  String namaPenerima;

  int isSynced;

  /// VERSI 50: data tambahan (disimpan di kolom extra sqlite)
  String asal;
  String namaCustomer;
  String gudang;
  String statusLabel;
  List<ItemDo> items;

  ListDo({
    required this.id,
    required this.tglEstimasiPickup,
    required this.jamEstimasiPickup,
    required this.tglEstimasiSampai,
    required this.jamEstimasiSampai,
    required this.refDate,
    required this.noDeliv,
    required this.shipVia,
    required this.poNumber,
    required this.alamatPickup,
    required this.alamatPengiriman,
    required this.memo,
    required this.status,
    required this.namaPenerima,
    this.isSynced = 0,
    this.asal = '',
    this.namaCustomer = '',
    this.gudang = '',
    this.statusLabel = '',
    List<ItemDo>? items,
  }) : items = items ?? <ItemDo>[];

  static List<ItemDo> _items(dynamic v) {
    if (v is List) {
      return v
          .whereType<Map>()
          .map((e) => ItemDo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return <ItemDo>[];
  }

  factory ListDo.fromJson(Map<String, dynamic> json) {
    final pickup = tanggalAman(json["tgl_estimasi_pickup"], DateTime.now());
    return ListDo(
      id: json["id"],
      tglEstimasiPickup: pickup,
      jamEstimasiPickup: teksAman(json["jam_estimasi_pickup"]),
      tglEstimasiSampai: tanggalAman(json["tgl_estimasi_sampai"], pickup),
      jamEstimasiSampai: teksAman(json["jam_estimasi_sampai"]),
      refDate: tanggalAman(json["ref_date"], pickup),
      noDeliv: teksAman(json["no_deliv"]),
      shipVia: teksAman(json["ship_via"]),
      poNumber: teksAman(json["po_number"]),
      alamatPickup: teksAman(json["alamat_pickup"]),
      alamatPengiriman: teksAman(json["alamat_pengiriman"]),
      memo: teksAman(json["memo"]),
      status: teksAman(json["status"]),
      namaPenerima: teksAman(json["nama_penerima"]),
      asal: teksAman(json["asal"], ''),
      namaCustomer: teksAman(json["nama_customer"] ?? json["nama_penerima"], ''),
      gudang: teksAman(json["gudang"], ''),
      statusLabel: teksAman(json["status_label"], ''),
      items: _items(json["items"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "tgl_estimasi_pickup": tglEstimasiPickup.toIso8601String(),
        "jam_estimasi_pickup": jamEstimasiPickup,
        "tgl_estimasi_sampai": tglEstimasiSampai.toIso8601String(),
        "jam_estimasi_sampai": jamEstimasiSampai,
        "ref_date": refDate.toIso8601String(),
        "no_deliv": noDeliv,
        "ship_via": shipVia,
        "po_number": poNumber,
        "alamat_pickup": alamatPickup,
        "alamat_pengiriman": alamatPengiriman,
        "memo": memo,
        "status": status,
        "nama_penerima": namaPenerima,
        "asal": asal,
        "nama_customer": namaCustomer,
        "gudang": gudang,
        "status_label": statusLabel,
        "items": items.map((e) => e.toJson()).toList(),
      };

  factory ListDo.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> extra = {};
    try {
      if (map["extra"] != null && map["extra"].toString().isNotEmpty) {
        extra = Map<String, dynamic>.from(jsonDecode(map["extra"]));
      }
    } catch (_) {}
    final pickup = tanggalAman(map["tgl_estimasi_pickup"], DateTime.now());
    return ListDo(
      id: map["id"],
      tglEstimasiPickup: pickup,
      jamEstimasiPickup: teksAman(map["jam_estimasi_pickup"]),
      tglEstimasiSampai: tanggalAman(map["tgl_estimasi_sampai"], pickup),
      jamEstimasiSampai: teksAman(map["jam_estimasi_sampai"]),
      refDate: tanggalAman(map["ref_date"], pickup),
      noDeliv: teksAman(map["no_deliv"]),
      shipVia: teksAman(map["ship_via"]),
      poNumber: teksAman(map["po_number"]),
      alamatPickup: teksAman(map["alamat_pickup"]),
      alamatPengiriman: teksAman(map["alamat_pengiriman"]),
      memo: teksAman(map["memo"]),
      status: teksAman(map["status"]),
      namaPenerima: teksAman(map["nama_penerima"]),
      isSynced: map["is_synced"] ?? 0,
      asal: teksAman(extra["asal"], ''),
      namaCustomer: teksAman(extra["nama_customer"], ''),
      gudang: teksAman(extra["gudang"], ''),
      statusLabel: teksAman(extra["status_label"], ''),
      items: _items(extra["items"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "tgl_estimasi_pickup": tglEstimasiPickup.toIso8601String(),
        "jam_estimasi_pickup": jamEstimasiPickup,
        "tgl_estimasi_sampai": tglEstimasiSampai.toIso8601String(),
        "jam_estimasi_sampai": jamEstimasiSampai,
        "ref_date": refDate.toIso8601String(),
        "no_deliv": noDeliv,
        "ship_via": shipVia,
        "po_number": poNumber,
        "alamat_pickup": alamatPickup,
        "alamat_pengiriman": alamatPengiriman,
        "memo": memo,
        "status": status,
        "nama_penerima": namaPenerima,
        "is_synced": isSynced,
        "extra": jsonEncode({
          "asal": asal,
          "nama_customer": namaCustomer,
          "gudang": gudang,
          "status_label": statusLabel,
          "items": items.map((e) => e.toJson()).toList(),
        }),
      };
}
