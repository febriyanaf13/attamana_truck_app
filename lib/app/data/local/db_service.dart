import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'attamana.db',
    );

    return await openDatabase(
      path,
      // VERSI 50: versi 2 -> kolom tambahan (lihat _upgradeKe2)
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _upgradeKe2(db);
        }
      },
      onCreate: (db, version) async {
        /// =========================
        /// DELIVERY ORDER
        /// =========================
        await db.execute('''
          CREATE TABLE delivery_order (

            no_deliv TEXT PRIMARY KEY,

            id TEXT,

            tgl_estimasi_pickup TEXT,
            jam_estimasi_pickup TEXT,

            tgl_estimasi_sampai TEXT,
            jam_estimasi_sampai TEXT,

            ref_date TEXT,

            ship_via TEXT,
            po_number TEXT,

            alamat_pickup TEXT,
            alamat_pengiriman TEXT,

            memo TEXT,

            status TEXT,

            nama_penerima TEXT,

            is_synced INTEGER,

            extra TEXT
          )
        ''');

        /// =========================
        /// DELIVERY PROGRESS
        /// =========================
        await db.execute('''
          CREATE TABLE delivery_progress (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            no_deliv TEXT,

            status TEXT,

            waktu TEXT,

            latitude REAL,

            longitude REAL,

            photo_paths TEXT,

            nama_penerima TEXT,

            is_synced INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE history_delivery_order (
          
            id TEXT PRIMARY KEY,
          
            tgl_estimasi_pickup TEXT,
            jam_estimasi_pickup TEXT,
          
            tgl_estimasi_sampai TEXT,
            jam_estimasi_sampai TEXT,
          
            ref_date TEXT,
          
            no_deliv TEXT,
            ship_via TEXT,
            po_number TEXT,
          
            alamat_pickup TEXT,
            alamat_pengiriman TEXT,
          
            memo TEXT,
            status TEXT,
          
            tanggal_diterima TEXT,
            jam_diterima TEXT,
          
            nama_penerima TEXT
          )
          ''');

        await db.execute('''
          CREATE TABLE history_delivery_detail (
          
            id TEXT PRIMARY KEY,
          
            tgl_estimasi_pickup TEXT,
          
            jam_estimasi_pickup TEXT,
          
            tgl_estimasi_sampai TEXT,
          
            jam_estimasi_sampai TEXT,
          
            ref_date TEXT,
          
            no_deliv TEXT,
          
            ship_via TEXT,
          
            po_number TEXT,
          
            alamat_pickup TEXT,
          
            alamat_pengiriman TEXT,
          
            memo TEXT,
          
            status TEXT,
          
            tanggal_diterima TEXT,
          
            jam_diterima TEXT,
          
            nama_penerima TEXT,
          
            picture TEXT
          )
          ''');

        /// =========================
        /// PENDING SYNC
        /// =========================
        await db.execute('''
          CREATE TABLE pending_sync (

            id INTEGER PRIMARY KEY AUTOINCREMENT,
            
            delivery_order_id TEXT UNIQUE,

            type TEXT,

            payload TEXT,

            created_at TEXT,

            is_synced INTEGER,

            no_deliv TEXT,

            last_error TEXT
          )
        ''');
      },
    );
  }

  /// VERSI 50:
  /// - delivery_order.extra  : data tambahan dari server (customer, gudang, daftar barang, dll) dalam JSON
  /// - pending_sync.no_deliv : kunci antrean offline per nomor DO (id terenkripsi dari server berubah tiap request)
  /// - pending_sync.last_error: pesan terakhir bila sinkronisasi belum berhasil
  static Future<void> _upgradeKe2(Database db) async {
    Future<void> tambahKolom(String tabel, String kolom) async {
      final info = await db.rawQuery('PRAGMA table_info($tabel)');
      if (!info.any((e) => e['name'] == kolom)) {
        await db.execute('ALTER TABLE $tabel ADD COLUMN $kolom TEXT');
      }
    }

    await tambahKolom('delivery_order', 'extra');
    await tambahKolom('pending_sync', 'no_deliv');
    await tambahKolom('pending_sync', 'last_error');
    // antrean dari versi lama: isi no_deliv dari data DO lokal
    await db.execute('''
      UPDATE pending_sync SET no_deliv = (
        SELECT d.no_deliv FROM delivery_order d WHERE d.id = pending_sync.delivery_order_id
      ) WHERE no_deliv IS NULL
    ''');
  }
}
