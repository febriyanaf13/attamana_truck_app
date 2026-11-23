import 'package:sqflite/sqflite.dart';

import '../models/pending_sync.dart';
import 'db_service.dart';

class PendingSyncLocal {
  Future<void> upsert(PendingSync data) async {
    final db = await DBService.database;

    await db.insert(
      'pending_sync',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PendingSync?> getByDoId(String doId) async {
    final db = await DBService.database;

    final result = await db.query(
      'pending_sync',
      where: 'delivery_order_id = ?',
      whereArgs: [doId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PendingSync.fromMap(
      result.first,
    );
  }

  Future<List<PendingSync>> getPending() async {
    final db = await DBService.database;

    final result = await db.query(
      'pending_sync',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((e) => PendingSync.fromMap(e)).toList();
  }

  Future<void> markAsSynced(String doId) async {
    final db = await DBService.database;

    await db.update(
      'pending_sync',
      {
        'is_synced': 1,
      },
      where: 'delivery_order_id = ?',
      whereArgs: [doId],
    );
  }

  Future<void> delete(String doId) async {
    final db = await DBService.database;

    await db.delete(
      'pending_sync',
      where: 'delivery_order_id = ?',
      whereArgs: [doId],
    );
  }

}
