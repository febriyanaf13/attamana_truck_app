import 'package:sqflite/sqflite.dart';

import '../models/delivery_progress.dart';

import 'db_service.dart';

class DeliveryProgressLocal {

  Future<void> insert(
      DeliveryProgress data) async {

    final db =
    await DBService.database;

    await db.insert(
      'delivery_progress',
      data.toMap(),
    );
  }

  Future<List<DeliveryProgress>>
  getUnsynced() async {

    final db =
    await DBService.database;

    final result = await db.query(

      'delivery_progress',

      where: 'is_synced = ?',

      whereArgs: [0],
    );

    return result
        .map((e) =>
        DeliveryProgress.fromMap(e))
        .toList();
  }

  Future<void> markAsSynced(
      int id) async {

    final db =
    await DBService.database;

    await db.update(

      'delivery_progress',

      {
        'is_synced': 1,
      },

      where: 'id = ?',

      whereArgs: [id],
    );
  }
}