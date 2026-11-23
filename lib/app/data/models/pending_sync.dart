class PendingSync {

  int? id;

  String deliveryOrderId;

  String payload;

  String createdAt;

  int isSynced;

  PendingSync({
    this.id,
    required this.deliveryOrderId,
    required this.payload,
    required this.createdAt,
    this.isSynced = 0,
  });

  factory PendingSync.fromMap(
      Map<String, dynamic> map) {

    return PendingSync(
      id: map['id'],
      deliveryOrderId:
      map['delivery_order_id'],
      payload: map['payload'],
      createdAt: map['created_at'],
      isSynced:
      map['is_synced'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {

    return {

      'id': id,

      'delivery_order_id':
      deliveryOrderId,

      'payload': payload,

      'created_at': createdAt,

      'is_synced': isSynced,
    };
  }
}