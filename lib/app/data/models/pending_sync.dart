/// Antrean offline 1 delivery order.
///
/// payload (JSON):
/// {
///   "no_deliv": "DO26-000001",
///   "delivery_order_id": "<id terenkripsi>",
///   "pickup":    {"tanggal": "yyyy-MM-dd", "jam": "HH:mm:ss"} | null,
///   "ongoing":   {"tanggal": "...", "jam": "...", "files": ["/path/foto.jpg", ...]} | null,
///   "delivered": {"tanggal": "...", "jam": "...", "nama_penerima": "...", "files": ["/path/foto.jpg"]} | null
/// }
class PendingSync {
  int? id;

  String deliveryOrderId;

  String payload;

  String createdAt;

  int isSynced;

  /// VERSI 50: kunci per nomor DO
  String? noDeliv;

  /// VERSI 50: pesan terakhir bila sinkronisasi belum berhasil
  String? lastError;

  PendingSync({
    this.id,
    required this.deliveryOrderId,
    required this.payload,
    required this.createdAt,
    this.isSynced = 0,
    this.noDeliv,
    this.lastError,
  });

  factory PendingSync.fromMap(Map<String, dynamic> map) {
    return PendingSync(
      id: map['id'],
      deliveryOrderId: map['delivery_order_id'],
      payload: map['payload'],
      createdAt: map['created_at'],
      isSynced: map['is_synced'] ?? 0,
      noDeliv: map['no_deliv'],
      lastError: map['last_error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'delivery_order_id': deliveryOrderId,
      'payload': payload,
      'created_at': createdAt,
      'is_synced': isSynced,
      'no_deliv': noDeliv,
      'last_error': lastError,
    };
  }
}
