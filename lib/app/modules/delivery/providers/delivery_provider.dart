import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/api_client.dart';
import '../../../data/api/my_api.dart';

/// VERSI 50: memakai ApiClient (token dibaca tiap request + perpanjang token otomatis).
class DeliveryProvider extends ApiClient {
  void _log(String api) {
    if (kDebugMode) print(api);
  }

  /// DO menunggu pickup (CONFIRM)
  Future<Response> getListDo(Map<String, dynamic> body) {
    _log(Api.deliveryOrder);
    return postApi(Api.deliveryOrder, () => body);
  }

  /// DO berjalan (PICKUP / ON DELIVERY)
  Future<Response> getListOnGoingDo(Map<String, dynamic> body) {
    _log(Api.onGoingDeliveryOrder);
    return postApi(Api.onGoingDeliveryOrder, () => body);
  }

  Future<Response> getDetailDo(String idDo) {
    final api = "${Api.detaiDeliveryOrder}/$idDo";
    _log(api);
    return getApi(api);
  }

  /// CONFIRM -> PICKUP
  Future<Response> postPickupDo({
    required dynamic userId,
    required String doId,
    String? tanggal,
    String? jam,
  }) {
    _log(Api.pickupDo);
    return postApi(
        Api.pickupDo,
        () => ApiClient.formMultipart({
              'userid': userId,
              'delivery_order_id': doId,
              'status': 'PICKUP',
              'tanggal': tanggal,
              'jam': jam,
            }, {}));
  }

  /// PICKUP -> ON DELIVERY (selesai loading), foto dikirim sebagai file_foto[]
  Future<Response> postUpdateSelesaiLoadingDo({
    required dynamic userId,
    required String doId,
    required List<String> foto,
    String? tanggal,
    String? jam,
  }) {
    _log(Api.selesaiLoadingDo);
    return postApi(
        Api.selesaiLoadingDo,
        () => ApiClient.formMultipart({
              'userid': userId,
              'delivery_order_id': doId,
              'status': 'ON DELIVERY',
              'tanggal': tanggal,
              'jam': jam,
            }, {
              'file_foto[]': foto
            }));
  }

  /// ON DELIVERY -> DELIVERED, nama penerima wajib, foto drop off file_foto[]
  Future<Response> postUpdateDeliveredDo({
    required dynamic userId,
    required String doId,
    required String namaPenerima,
    required List<String> foto,
    String? tanggal,
    String? jam,
  }) {
    _log(Api.deliveredDo);
    return postApi(
        Api.deliveredDo,
        () => ApiClient.formMultipart({
              'userid': userId,
              'delivery_order_id': doId,
              'status': 'DELIVERED',
              'nama_penerima': namaPenerima,
              'tanggal_diterima': tanggal,
              'jam_diterima': jam,
            }, {
              'file_foto[]': foto
            }));
  }

  /// sinkronisasi 1 DO yang tersimpan offline (format baru, multipart dengan foto).
  Future<Response> syncDelivery({
    required Map<String, dynamic> fields,
    required List<String> fotoLoading,
    required List<String> fotoDelivered,
  }) {
    _log(Api.sinkronisasiDoLokal);
    return postApi(
        Api.sinkronisasiDoLokal,
        () => ApiClient.formMultipart(fields, {
              'loading_foto[]': fotoLoading,
              'delivered_foto[]': fotoDelivered,
            }));
  }
}
