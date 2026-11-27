// To parse this JSON data, do
//
//     final historyDoDetail = historyDoDetailFromJson(jsonString);

import 'dart:convert';

List<HistoryDoDetail> historyDoDetailFromJson(List lst) =>
    List<HistoryDoDetail>.from(lst.map((x) => HistoryDoDetail.fromJson(x)));

String historyDoDetailToJson(List<HistoryDoDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryDoDetail {
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
  List<Picture> picture;

  HistoryDoDetail({
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
    required this.picture,
  });

  factory HistoryDoDetail.fromJson(
      Map<String, dynamic> json) =>
      HistoryDoDetail(

        id: json["id"],

        tglEstimasiPickup:
        parseDate(
          json["tgl_estimasi_pickup"],
        ),

        jamEstimasiPickup:
        json["jam_estimasi_pickup"] ?? '-',

        tglEstimasiSampai:
        parseDate(
          json["tgl_estimasi_sampai"],
        ),

        jamEstimasiSampai:
        json["jam_estimasi_sampai"] ?? '-',

        refDate:
        parseDate(
          json["ref_date"],
        ),

        noDeliv:
        json["no_deliv"] ?? '-',

        shipVia:
        json["ship_via"] ?? '-',

        poNumber:
        json["po_number"] ?? '-',

        alamatPickup:
        json["alamat_pickup"] ?? '-',

        alamatPengiriman:
        json["alamat_pengiriman"] ?? '-',

        memo:
        json["memo"] ?? '-',

        status:
        json["status"] ?? '-',

        tanggalDiterima:
        parseDate(
          json["tanggal_diterima"],
        ),

        jamDiterima:
        json["jam_diterima"] ?? '-',

        namaPenerima:
        json["nama_penerima"] ?? '-',

        picture:
        json["picture"] == null
            ? []
            : List<Picture>.from(
          json["picture"].map(
                (x) => Picture
                .fromJson(x),
          ),
        ),
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
        "picture": List<dynamic>.from(picture.map((x) => x.toJson())),
      };

  factory HistoryDoDetail.fromMap(Map<String, dynamic> map) {
    return HistoryDoDetail(
      id: map["id"],
      tglEstimasiPickup: parseDate(map["tgl_estimasi_pickup"]),
      jamEstimasiPickup: (map["jam_estimasi_pickup"] ?? '-').toString(),
      tglEstimasiSampai: parseDate(map["tgl_estimasi_sampai"]),
      jamEstimasiSampai: (map["jam_estimasi_sampai"] ?? '-').toString(),
      refDate: parseDate(map["ref_date"]),
      noDeliv: (map["no_deliv"] ?? '-').toString(),
      shipVia: (map["ship_via"] ?? '-').toString(),
      poNumber: (map["po_number"] ?? '-').toString(),
      alamatPickup: (map["alamat_pickup"] ?? '-').toString(),
      alamatPengiriman: (map["alamat_pengiriman"] ?? '-').toString(),
      memo: (map["memo"] ?? '-').toString(),
      status: (map["status"] ?? '-').toString(),
      tanggalDiterima: parseDate(map["tanggal_diterima"]),
      jamDiterima: (map["jam_diterima"] ?? '-').toString(),
      namaPenerima: (map["nama_penerima"] ?? '-').toString(),
      picture: (map["picture"] == null || map["picture"].toString().isEmpty)
          ? <Picture>[]
          : List<Picture>.from(
              jsonDecode(
                map["picture"],
              ).map(
                (x) => Picture.fromJson(x),
              ),
            ),
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

        "tanggal_diterima": tanggalDiterima.toIso8601String(),

        "jam_diterima": jamDiterima,

        "nama_penerima": namaPenerima,

        /// SAVE JSON STRING
        "picture": jsonEncode(
          picture.map((e) => e.toJson()).toList(),
        ),
      };


  static DateTime parseDate(
      dynamic value) {

    if (value == null ||
        value == '' ||
        value == '0000-00-00') {

      return DateTime.now();
    }

    return DateTime.tryParse(
        value.toString()) ??
        DateTime.now();
  }
}

class Picture {
  String fileFoto;
  String keterangan;

  Picture({
    required this.fileFoto,
    required this.keterangan,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        fileFoto: (json["file_foto"] ?? '').toString(),
        keterangan: (json["keterangan"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "file_foto": fileFoto,
        "keterangan": keterangan,
      };
}


