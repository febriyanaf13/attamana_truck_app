import 'dart:convert';

List<ListDo> listDoFromJson(List lst) =>
    List<ListDo>.from(lst.map((x) => ListDo.fromJson(x)));

String listDoToJson(List<ListDo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  /// tambahan untuk offline sync
  int isSynced;

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
  });

  factory ListDo.fromJson(Map<String, dynamic> json) => ListDo(
    id: json["id"],
    tglEstimasiPickup:
    DateTime.parse(json["tgl_estimasi_pickup"]),
    jamEstimasiPickup: json["jam_estimasi_pickup"] ?? '-',
    tglEstimasiSampai:
    DateTime.parse(json["tgl_estimasi_sampai"]),
    jamEstimasiSampai: json["jam_estimasi_sampai"] ?? '-',
    refDate: DateTime.parse(json["ref_date"]),
    noDeliv: json["no_deliv"] ?? '-',
    shipVia: json["ship_via"] ?? '-',
    poNumber: json["po_number"] ?? '-',
    alamatPickup: json["alamat_pickup"] ?? '-',
    alamatPengiriman: json["alamat_pengiriman"] ?? '-',
    memo: json["memo"] ?? '-',
    status: json["status"] ?? '-',
    namaPenerima: json["nama_penerima"] ?? '-',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tgl_estimasi_pickup":
    tglEstimasiPickup.toIso8601String(),
    "jam_estimasi_pickup": jamEstimasiPickup,
    "tgl_estimasi_sampai":
    tglEstimasiSampai.toIso8601String(),
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
  };

  /// =========================
  /// SQLITE
  /// =========================

  factory ListDo.fromMap(Map<String, dynamic> map) => ListDo(
    id: map["id"],
    tglEstimasiPickup:
    DateTime.parse(map["tgl_estimasi_pickup"]),
    jamEstimasiPickup: map["jam_estimasi_pickup"],
    tglEstimasiSampai:
    DateTime.parse(map["tgl_estimasi_sampai"]),
    jamEstimasiSampai: map["jam_estimasi_sampai"],
    refDate: DateTime.parse(map["ref_date"]),
    noDeliv: map["no_deliv"],
    shipVia: map["ship_via"],
    poNumber: map["po_number"],
    alamatPickup: map["alamat_pickup"],
    alamatPengiriman: map["alamat_pengiriman"],
    memo: map["memo"],
    status: map["status"],
    namaPenerima: map["nama_penerima"],
    isSynced: map["is_synced"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "tgl_estimasi_pickup":
    tglEstimasiPickup.toIso8601String(),
    "jam_estimasi_pickup": jamEstimasiPickup,
    "tgl_estimasi_sampai":
    tglEstimasiSampai.toIso8601String(),
    "jam_estimasi_sampai": jamEstimasiSampai,
    "ref_date":
    refDate.toIso8601String(),
    "no_deliv": noDeliv,
    "ship_via": shipVia,
    "po_number": poNumber,
    "alamat_pickup": alamatPickup,
    "alamat_pengiriman": alamatPengiriman,
    "memo": memo,
    "status": status,
    "nama_penerima": namaPenerima,
    "is_synced": isSynced,
  };
}