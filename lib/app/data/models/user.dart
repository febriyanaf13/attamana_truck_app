// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(List lst) =>
    List<User>.from(lst.map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  dynamic userid;
  dynamic pegawaiId;
  String username;
  String nama;
  String email;
  String telepon;
  String initial;
  dynamic lokasiAbsen;
  String geometryLokasi;
  List<String>? geometryAbsen;
  String statusKaryawan;
  List<Role> roles;

  User({
    required this.userid,
    required this.pegawaiId,
    required this.username,
    required this.nama,
    required this.email,
    required this.telepon,
    required this.initial,
    required this.lokasiAbsen,
    required this.geometryLokasi,
    required this.geometryAbsen,
    required this.statusKaryawan,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["userid"],
        pegawaiId: json["pegawai_id"],
        username: json["username"],
        nama: json["nama"],
        email: json["email"],
        telepon: json["telepon"],
        initial: json["initial"],
        lokasiAbsen: json["lokasi_absen"],
        geometryLokasi: json["geometry_lokasi"],
        geometryAbsen: json['geometry_absen'] == null
            ? []
            : List<String>.from(json['geometry_absen']),
        statusKaryawan: json["status_karyawan"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "pegawai_id": pegawaiId,
        "username": username,
        "nama": nama,
        "email": email,
        "telepon": telepon,
        "initial": initial,
        "lokasi_absen": lokasiAbsen,
        "geometry_lokasi": geometryLokasi,
        "geometry_absen": geometryAbsen,
        "status_karyawan": statusKaryawan,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  int roleId;
  String roleName;

  Role({
    required this.roleId,
    required this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["role_id"],
        roleName: json["role_name"],
      );

  Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
      };
}
