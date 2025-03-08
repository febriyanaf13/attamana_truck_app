// To parse this JSON data, do
//
//     final shift = shiftFromJson(jsonString);

import 'dart:convert';

Shift shiftFromJson(String str) => Shift.fromJson(json.decode(str));

String shiftToJson(Shift data) => json.encode(data.toJson());

class Shift {
  List<Datum> data;

  Shift({
    required this.data,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String nama;
  String jamMasuk;
  String jamPulang;
  String toleransiTerlambat;
  dynamic userCreated;
  dynamic userModified;
  DateTime created;
  DateTime modified;

  Datum({
    required this.id,
    required this.nama,
    required this.jamMasuk,
    required this.jamPulang,
    required this.toleransiTerlambat,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        jamMasuk: json["jam_masuk"],
        jamPulang: json["jam_pulang"],
        toleransiTerlambat: json["toleransi_terlambat"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "jam_masuk": jamMasuk,
        "jam_pulang": jamPulang,
        "toleransi_terlambat": toleransiTerlambat,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}
