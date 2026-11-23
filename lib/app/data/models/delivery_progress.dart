class DeliveryProgress {

  int? id;

  String noDeliv;

  String status;

  String waktu;

  double latitude;

  double longitude;

  String photoPaths;

  String? namaPenerima;

  int isSynced;

  DeliveryProgress({

    this.id,

    required this.noDeliv,

    required this.status,

    required this.waktu,

    required this.latitude,

    required this.longitude,

    required this.photoPaths,

    this.namaPenerima,

    required this.isSynced,
  });

  factory DeliveryProgress.fromMap(
      Map<String, dynamic> map) {

    return DeliveryProgress(

      id: map['id'],

      noDeliv:
      map['no_deliv'],

      status:
      map['status'],

      waktu:
      map['waktu'],

      latitude:
      map['latitude'],

      longitude:
      map['longitude'],

      photoPaths:
      map['photo_paths'],

      namaPenerima:
      map['nama_penerima'],

      isSynced:
      map['is_synced'],
    );
  }

  Map<String, dynamic> toMap() {

    return {

      'id': id,

      'no_deliv': noDeliv,

      'status': status,

      'waktu': waktu,

      'latitude': latitude,

      'longitude': longitude,

      'photo_paths': photoPaths,

      'nama_penerima':
      namaPenerima,

      'is_synced': isSynced,
    };
  }
}