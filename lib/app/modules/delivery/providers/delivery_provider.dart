import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';

class DeliveryProvider extends GetConnect {
  var token = storage.read(kToken);

  Future<Response> getListDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = Api.deliveryOrder;
    print(api);

    return post(api, body, headers: headers);
  }

  Future<Response> getListOnGoingDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };

    var api = Api.onGoingDeliveryOrder;
    if (kDebugMode) {
      print(api);
    }

    return post(api, body, headers: headers);
  }

  Future<Response> getDetailDo(idDo) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = "${Api.detaiDeliveryOrder}/$idDo";
    if (kDebugMode) {
      print(api);
    }

    return get(api, headers: headers);
  }

  Future<Response> postUpdateSelesaiLoadingDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = Api.selesaiLoadingDo;
    if (kDebugMode) {
      print(api);
    }

    return post(api, body, headers: headers);
  }

  Future<Response> postUpdateDeliveredDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = Api.deliveredDo;
    if (kDebugMode) {
      print(api);
    }

    return post(api, body, headers: headers);
  }

  Future<Response> postPickupDo(body) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    var api = Api.pickupDo;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }
}
