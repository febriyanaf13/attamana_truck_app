import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/api_client.dart';
import '../../../data/api/my_api.dart';

/// VERSI 50: memakai ApiClient (token dibaca tiap request + perpanjang token otomatis).
class HistoryDoProvider extends ApiClient {
  Future<Response> getHistoryDo(Map<String, dynamic> body) {
    if (kDebugMode) print(Api.historyDo);
    return postApi(Api.historyDo, () => body);
  }

  Future<Response> getHistoryDoDetail(String doId) {
    final api = "${Api.historyDoDetail}/$doId";
    if (kDebugMode) print(api);
    return getApi(api);
  }
}
