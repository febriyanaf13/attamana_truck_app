import 'package:sqflite/sqflite.dart';

import '../../modules/delivery/models/delivery_order.dart';

import 'db_service.dart';

class DeliveryOrderLocal {

  Future<void> insert(
      ListDo data) async {

    final db =
    await DBService.database;

    await db.insert(

      'delivery_order',

      data.toMap(),

      conflictAlgorithm:
      ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(
      List<ListDo> list) async {

    final db =
    await DBService.database;

    Batch batch = db.batch();

    for (var item in list) {

      batch.insert(

        'delivery_order',

        item.toMap(),

        conflictAlgorithm:
        ConflictAlgorithm.replace,
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  Future<List<ListDo>>
  getAll() async {

    final db =
    await DBService.database;

    final result =
    await db.query(
        'delivery_order');

    return result
        .map((e) =>
        ListDo.fromMap(e))
        .toList();
  }

  Future<List<ListDo>>
  getByStatus(
      String status) async {

    final db =
    await DBService.database;

    final result = await db.query(

      'delivery_order',

      where: 'status = ?',

      whereArgs: [status],
    );

    return result
        .map((e) =>
        ListDo.fromMap(e))
        .toList();
  }

  Future<List<ListDo>>
  getByStatuses(
      List<String> statuses) async {

    final db =
    await DBService.database;

    final placeholders =
    List.generate(
      statuses.length,
          (_) => '?',
    ).join(',');

    final result = await db.query(

      'delivery_order',

      where:
      'status IN ($placeholders)',

      whereArgs: statuses,
    );

    return result
        .map((e) => ListDo.fromMap(e))
        .toList();
  }

  Future<ListDo?> getById(
      String id) async {

    final db =
    await DBService.database;

    final result = await db.query(

      'delivery_order',

      where: 'id = ?',

      whereArgs: [id],

      limit: 1,
    );

    if (result.isNotEmpty) {

      return ListDo.fromMap(
        result.first,
      );
    }

    return null;
  }

  Future<void> updateStatus({

    required String noDeliv,

    required String status,

    String? namaPenerima,

  }) async {

    final db =
    await DBService.database;

    Map<String, dynamic> data = {

      'status': status,
    };

    /// hanya update jika ada isi
    if (namaPenerima != null) {

      data['nama_penerima'] =
          namaPenerima;
    }

    await db.update(

      'delivery_order',

      data,

      where: 'no_deliv = ?',

      whereArgs: [noDeliv],
    );
  }

  /// VERSI 50: ambil 1 DO lokal berdasarkan nomor DO
  Future<ListDo?> getByNoDeliv(String noDeliv) async {
    final db = await DBService.database;
    final result = await db.query('delivery_order',
        where: 'no_deliv = ?', whereArgs: [noDeliv], limit: 1);
    return result.isNotEmpty ? ListDo.fromMap(result.first) : null;
  }

  /// VERSI 50: samakan data lokal berstatus [statuses] dengan daftar dari server.
  /// - DO dari server disimpan / diperbarui (kecuali DO yang masih punya antrean offline [tertunda])
  /// - DO lokal berstatus [statuses] yang sudah tidak ada di server dihapus
  ///   (mis. sudah diproses lewat web, di-void, atau di-reset), kecuali yang masih tertunda
  Future<void> sinkronkan(
      List<ListDo> server, List<String> statuses, Set<String> tertunda) async {
    final db = await DBService.database;
    final noServer = server.map((e) => e.noDeliv).toSet();
    await db.transaction((txn) async {
      final lokal = await txn.query('delivery_order',
          columns: ['no_deliv', 'status']);
      for (final row in lokal) {
        final no = (row['no_deliv'] ?? '').toString();
        if (statuses.contains(row['status']) &&
            !noServer.contains(no) &&
            !tertunda.contains(no)) {
          await txn.delete('delivery_order',
              where: 'no_deliv = ?', whereArgs: [no]);
        }
      }
      for (final item in server) {
        if (tertunda.contains(item.noDeliv)) continue;
        await txn.insert('delivery_order', item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  /// VERSI 50: buang DO yang sudah selesai (DELIVERED / DONE / VOID ...) dan tidak punya antrean offline
  Future<void> hapusYangSelesai(Set<String> tertunda) async {
    final db = await DBService.database;
    final lokal = await db.query('delivery_order', columns: ['no_deliv', 'status']);
    for (final row in lokal) {
      final no = (row['no_deliv'] ?? '').toString();
      if (!['CONFIRM', 'PICKUP', 'ON DELIVERY'].contains(row['status']) &&
          !tertunda.contains(no)) {
        await db.delete('delivery_order', where: 'no_deliv = ?', whereArgs: [no]);
      }
    }
  }
}
