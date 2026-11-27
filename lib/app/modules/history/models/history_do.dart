import 'dart:convert';

import '../../delivery/models/delivery_order.dart' show tanggalAman, teksAman;

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
        tglEstimasiPickup: tanggalAman(json["tgl_estimasi_pickup"]),
        jamEstimasiPickup: teksAman(json["jam_estimasi_pickup"]),
        tglEstimasiSampai: tanggalAman(json["tgl_estimasi_sampai"]),
        jamEstimasiSampai: teksAman(json["jam_estimasi_sampai"]),
        refDate: tanggalAman(json["ref_date"]),
        noDeliv: teksAman(json["no_deliv"]),
        shipVia: teksAman(json["ship_via"]),
        poNumber: teksAman(json["po_number"]),
        alamatPickup: teksAman(json["alamat_pickup"]),
        alamatPengiriman: teksAman(json["alamat_pengiriman"]),
        memo: teksAman(json["memo"]),
        status: teksAman(json["status"]),
        tanggalDiterima: tanggalAman(json["tanggal_diterima"]),
        jamDiterima: teksAman(json["jam_diterima"]),
        namaPenerima: teksAman(json["nama_penerima"]),
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

  factory HistoryDo.fromMap(Map<String, dynamic> map) => HistoryDo(
        id: map["id"],
        tglEstimasiPickup: tanggalAman(map["tgl_estimasi_pickup"]),
        jamEstimasiPickup: teksAman(map["jam_estimasi_pickup"]),
        tglEstimasiSampai: tanggalAman(map["tgl_estimasi_sampai"]),
        jamEstimasiSampai: teksAman(map["jam_estimasi_sampai"]),
        refDate: tanggalAman(map["ref_date"]),
        noDeliv: teksAman(map["no_deliv"]),
        shipVia: teksAman(map["ship_via"]),
        poNumber: teksAman(map["po_number"]),
        alamatPickup: teksAman(map["alamat_pickup"]),
        alamatPengiriman: teksAman(map["alamat_pengiriman"]),
        memo: teksAman(map["memo"]),
        status: teksAman(map["status"]),
        tanggalDiterima: tanggalAman(map["tanggal_diterima"]),
        jamDiterima: teksAman(map["jam_diterima"]),
        namaPenerima: teksAman(map["nama_penerima"]),
      );

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
        "tanggal_diterima": tanggalDiterima.toIso8601String(),
        "jam_diterima": jamDiterima,
        "nama_penerima": namaPenerima,
      };
}
