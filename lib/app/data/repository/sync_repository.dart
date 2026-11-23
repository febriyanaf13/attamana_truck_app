import 'dart:convert';

import '../local/pending_sync_local.dart';
import '../../modules/delivery/providers/delivery_provider.dart';

class SyncRepository {
  final PendingSyncLocal pendingLocal = PendingSyncLocal();

  Future<void> syncData(userId) async {
    try {
      /// =========================
      /// GET PENDING
      /// =========================
      final pendingList = await pendingLocal.getPending();

      if (pendingList.isEmpty) {
        print(
          'Tidak ada data yang perlu sync',
        );

        return;
      }

      /// =========================
      /// BUILD REQUEST
      /// =========================
      final body = {
        "userid": userId,
        "delivery_orders": pendingList.map((e) {
          return jsonDecode(
            e.payload,
          );
        }).toList(),
      };

      print(
        const JsonEncoder.withIndent('  ').convert(body),
      );

      /// =========================
      /// HIT API
      /// =========================
      ///
      /// contoh:
      ///
      /// final response =
      await DeliveryProvider().syncDelivery(body);

      final response = await DeliveryProvider().syncDelivery(body);

      print(response.body);

      if (response.status.isOk) {
        final success = response.body['success'];

        if (success == true) {
          /// mark synced
          for (final item in pendingList) {
            await pendingLocal.markAsSynced(
              item.deliveryOrderId,
            );
          }

          print('SYNC SUCCESS');
        } else {
          print(
            'SYNC FAILED : ${response.body['message']}',
          );
        }
      } else {
        print(
          'HTTP ERROR : ${response.statusCode}',
        );
      }
    } catch (e) {
      print(
        'SYNC ERROR : $e',
      );
    }
  }

  Future<void> printSyncRequest(int userId) async {
    final pendingList = await pendingLocal.getPending();

    final body = {
      "userid": userId,
      "delivery_orders": pendingList.map((e) {
        return jsonDecode(
          e.payload,
        );
      }).toList(),
    };

    print(
      const JsonEncoder.withIndent('  ').convert(body),
    );
  }
}
