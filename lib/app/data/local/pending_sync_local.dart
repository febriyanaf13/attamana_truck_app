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

  /// VERSI 50: antrean yang belum terkirim untuk nomor DO ini
  Future<PendingSync?> getByNoDeliv(String noDeliv) async {
    final db = await DBService.database;

    final result = await db.query(
      'pending_sync',
      where: 'no_deliv = ? AND is_synced = 0',
      whereArgs: [noDeliv],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PendingSync.fromMap(result.first);
  }

  Future<List<PendingSync>> getPending() async {
    final db = await DBService.database;

    final result = await db.query(
      'pending_sync',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'id',
    );

    return result.map((e) => PendingSync.fromMap(e)).toList();
  }

  /// VERSI 50: nomor DO yang masih punya antrean offline (tidak boleh ditimpa data server)
  Future<Set<String>> noDelivTertunda() async {
    final list = await getPending();
    return list
        .map((e) => e.noDeliv ?? '')
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  Future<void> setError(int id, String? pesan) async {
    final db = await DBService.database;
    await db.update('pending_sync', {'last_error': pesan},
        where: 'id = ?', whereArgs: [id]);
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

  Future<void> deleteById(int id) async {
    final db = await DBService.database;
    await db.delete('pending_sync', where: 'id = ?', whereArgs: [id]);
  }
}
