import 'package:sqflite/sqflite.dart';

import '../../modules/history/models/history_do_detail.dart';
import 'db_service.dart';

class HistoryDoDetailLocal {
  /// =========================
  /// INSERT
  /// =========================
  Future<void> insert(HistoryDoDetail data) async {
    final db = await DBService.database;

    await db.insert(
      'history_delivery_detail',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<HistoryDoDetail> list) async {
    final db = await DBService.database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'history_delivery_detail',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  Future<void> update(
      HistoryDoDetail data) async {

    final db = await DBService.database;

    await db.update(

      'history_delivery_detail',

      data.toMap(),

      where: 'id = ?',

      whereArgs: [data.id],
    );
  }

  Future<List<HistoryDoDetail>> getByDoId(String id) async {
    final db = await DBService.database;

    final result = await db.query(
      'history_delivery_detail',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.map((e) => HistoryDoDetail.fromMap(e)).toList();
  }

  /// =========================
  /// GET DETAIL
  /// =========================
  Future<HistoryDoDetail?> getById(String id) async {
    final db = await DBService.database;

    final result = await db.query(
      'history_delivery_detail',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return HistoryDoDetail.fromMap(
        result.first,
      );
    }

    return null;
  }

  /// =========================
  /// GET ALL
  /// =========================

  Future<List<HistoryDoDetail>> getAll() async {
    final db = await DBService.database;

    final result = await db.query(
      'history_delivery_detail',
    );

    return result.map((e) => HistoryDoDetail.fromMap(e)).toList();
  }
}
