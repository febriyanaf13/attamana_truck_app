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

  /// VERSI 50: data server menjadi acuan. Baris lokal dihapus lalu diganti data server,
  /// kecuali DO yang diselesaikan offline dan belum terkirim ([tertunda]).
  /// (dulu id terenkripsi yang selalu berubah membuat baris riwayat terus bertambah ganda)
  Future<void> gantiDariServer(List<HistoryDo> server, Set<String> tertunda) async {
    final db = await DBService.database;
    await db.transaction((txn) async {
      final lokal = await txn.query('history_delivery_order', columns: ['id', 'no_deliv']);
      for (final row in lokal) {
        if (!tertunda.contains((row['no_deliv'] ?? '').toString())) {
          await txn.delete('history_delivery_order', where: 'id = ?', whereArgs: [row['id']]);
        }
      }
      for (final item in server) {
        await txn.delete('history_delivery_order',
            where: 'no_deliv = ?', whereArgs: [item.noDeliv]);
        await txn.insert('history_delivery_order', item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<HistoryDo?> getById(String id) async {
    final db = await DBService.database;
    final result = await db.query('history_delivery_order',
        where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? HistoryDo.fromMap(result.first) : null;
  }

  Future<void> deleteByNoDeliv(String noDeliv) async {
    final db = await DBService.database;
    await db.delete('history_delivery_order', where: 'no_deliv = ?', whereArgs: [noDeliv]);
  }
}
