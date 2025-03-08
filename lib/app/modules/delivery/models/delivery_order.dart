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
  });

  factory ListDo.fromJson(Map<String, dynamic> json) => ListDo(
        id: json["id"],
        tglEstimasiPickup:
            DateTime.parse(json["tgl_estimasi_pickup"] ?? '0000-00-00'),
        jamEstimasiPickup: json["jam_estimasi_pickup"],
        tglEstimasiSampai:
            DateTime.parse(json["tgl_estimasi_sampai"] ?? '0000-00-00'),
        jamEstimasiSampai: json["jam_estimasi_sampai"] ?? '-',
        refDate: DateTime.parse(json["ref_date"] ?? '0000-00-00'),
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
            "${tglEstimasiPickup.year.toString().padLeft(4, '0')}-${tglEstimasiPickup.month.toString().padLeft(2, '0')}-${tglEstimasiPickup.day.toString().padLeft(2, '0')}",
        "jam_estimasi_pickup": jamEstimasiPickup,
        "tgl_estimasi_sampai":
            "${tglEstimasiSampai.year.toString().padLeft(4, '0')}-${tglEstimasiSampai.month.toString().padLeft(2, '0')}-${tglEstimasiSampai.day.toString().padLeft(2, '0')}",
        "jam_estimasi_sampai": jamEstimasiSampai,
    "ref_date":
    "${refDate.year.toString().padLeft(4, '0')}-${refDate.month.toString().padLeft(2, '0')}-${refDate.day.toString().padLeft(2, '0')}",
        "no_deliv": noDeliv,
        "ship_via": shipVia,
        "po_number": poNumber,
        "alamat_pickup": alamatPickup,
        "alamat_pengiriman": alamatPengiriman,
        "memo": memo,
        "status": status,
        "nama_penerima": namaPenerima
      };
}
