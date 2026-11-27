import 'package:get/get.dart';

import '../../../data/api/my_api.dart';

class AuthProvider extends GetConnect {
  // request token
  // VERSI 50: server (ApiController@authenticate) mewajibkan parameter version yang sama dengan
  // tabel tokens. Dulu version tidak dikirim, sehingga token selalu ditolak
  // ("Maaf aplikasi bukan versi terbaru").
  Future<Response> reqToken(String username, String password,
      {String version = ''}) {
    final body = FormData({
      'username': username,
      'password': password,
      'version': version,
    });
    return post(Api.token, body);
  }

  //post login
  Future<Response> postLogin(String username, String password, String token) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    final body = FormData({
      'username': username,
      'password': password,
    });
    var api = Api.login;
    print(api);
    return post(api, body, headers: headers);
  }
}
