import '../local/delivery_order_local.dart';



import '../local/delivery_progress_local.dart';
import '../local/pending_sync_local.dart';

class DeliveryProgressRepository {

  final DeliveryProgressLocal
  progressLocal =
  DeliveryProgressLocal();

  final PendingSyncLocal
  pendingLocal =
  PendingSyncLocal();

  final DeliveryOrderLocal
  orderLocal =
  DeliveryOrderLocal();
}