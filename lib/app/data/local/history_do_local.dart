import 'package:sqflite/sqflite.dart';

import '../../modules/history/models/history_do.dart';
import 'db_service.dart';

class HistoryDoLocal {

  /// =========================
  /// INSERT SINGLE
  /// =========================
  Future<void> insert(
      HistoryDo data) async {

    final db =
    await DBService.database;

    await db.insert(
      'history_delivery_order',
      data.toMap(),
      conflictAlgorithm:
      ConflictAlgorithm.replace,
    );
  }
  /// =========================
  /// INSERT ALL
  /// =========================
  Future<void> insertAll(List<HistoryDo> list) async {
    final db = await DBService.database;

    Batch batch = db.batch();

    for (var item in list) {
      batch.insert(
        'history_delivery_order',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  /// =========================
  /// GET ALL
  /// =========================

  Future<List<HistoryDo>> getAll() async {
    final db = await DBService.database;

    final result = await db.query(
      'history_delivery_order',
    );

    return result.map((e) => HistoryDo.fromMap(e)).toList();
  }
}
