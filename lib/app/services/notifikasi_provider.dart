import 'package:get/get.dart';

import '../data/api/api_client.dart';
import '../data/api/my_api.dart';
import '../utils/constants.dart';
import '../utils/string_utils.dart';

/// VERSI 52: API token HP & notifikasi (endpoint yang sama dengan aplikasi sales, aplikasi = TRUCK)
class NotifikasiProvider extends ApiClient {
  Future<Response> simpanPerangkat(String token, String platform, String versi) =>
      postApi(
          Api.notifikasiPerangkat,
          () => {
                'userid': '${storage.read(kUserId)}',
                'token': token,
                'platform': platform,
                'aplikasi': 'TRUCK',
                'versi_app': versi,
              });

  Future<Response> hapusPerangkat(String token) =>
      postApi(Api.notifikasiPerangkatHapus, () => {'token': token});

  Future<Response> baca(List<int> ids) => postApi(
      Api.notifikasiBaca,
      () => {'userid': '${storage.read(kUserId)}', 'id': ids.join(',')});
}
