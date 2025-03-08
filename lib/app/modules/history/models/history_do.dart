import 'dart:convert';

List<HistoryDo> historyDoFromJson(List lst) =>
    List<HistoryDo>.from(lst.map((x) => HistoryDo.fromJson(x)));

String historyDoToJson(List<HistoryDo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryDo {
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
  String memo;
  String status;
  DateTime tanggalDiterima;
  String jamDiterima;
  String namaPenerima;

  HistoryDo({
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
    required this.tanggalDiterima,
    required this.jamDiterima,
    required this.namaPenerima,
  });

  factory HistoryDo.fromJson(Map<String, dynamic> json) => HistoryDo(
        id: json["id"],
        tglEstimasiPickup: DateTime.parse(json["tgl_estimasi_pickup"]),
        jamEstimasiPickup: json["jam_estimasi_pickup"],
        tglEstimasiSampai: DateTime.parse(json["tgl_estimasi_sampai"]),
        jamEstimasiSampai: json["jam_estimasi_sampai"],
        refDate: DateTime.parse(json["ref_date"] ?? '0000-00-00'),
        noDeliv: json["no_deliv"],
        shipVia: json["ship_via"],
        poNumber: json["po_number"],
        alamatPickup: json["alamat_pickup"],
        alamatPengiriman: json["alamat_pengiriman"],
        memo: json["memo"],
        status: json["status"],
        tanggalDiterima: DateTime.parse(json["tanggal_diterima"]),
        jamDiterima: json["jam_diterima"],
        namaPenerima: json["nama_penerima"],
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
        "tanggal_diterima":
            "${tanggalDiterima.year.toString().padLeft(4, '0')}-${tanggalDiterima.month.toString().padLeft(2, '0')}-${tanggalDiterima.day.toString().padLeft(2, '0')}",
        "jam_diterima": jamDiterima,
        "nama_penerima": namaPenerima,
      };
}
