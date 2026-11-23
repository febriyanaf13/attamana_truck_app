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
}