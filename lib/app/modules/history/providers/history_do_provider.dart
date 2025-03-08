import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string_utils.dart';

class HistoryDoProvider extends GetConnect {
  var token = storage.read(kToken);

  Future<Response> getHistoryDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = Api.historyDo;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> getHistoryDoDetail(doId) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = "${Api.historyDoDetail}/$doId";
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
