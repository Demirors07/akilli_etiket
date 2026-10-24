import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  // Singleton Pattern: Uygulama genelinde tek bir veritabanı bağlantısı yönetilir
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_label.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        // SQLite yabancı anahtar (Foreign Key) desteğini aktif eder
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Tabloların İlk Oluşturulma Şeması (DDL ve Kısıtlar)
  Future<void> _createDB(Database db, int version) async {
    // 1. Bileşenler (Ingredients) Ana Tablosu
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NULL,
        canonical_name TEXT NOT NULL,
        description TEXT NULL
      )
    ''');

    // 2. Alternatif Arama Terimleri Tablosu (UNIQUE kısıtı ile mükerrer kayıt önlenir)
    await db.execute('''
      CREATE TABLE ingredient_search_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL,
        search_term TEXT NOT NULL,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE,
        UNIQUE (ingredient_id, search_term)
      )
    ''');

    // 3. Kategoriler Tablosu (CHECK kısıtı ile sadece geçerli tipler kabul edilir)
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        category_name TEXT NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('ALLERGEN', 'DIET')),
        description TEXT NULL
      )
    ''');

    // 4. Kullanıcı Tercihleri Tablosu (CHECK kısıtı ile boolean 0/1 zorunluluğu)
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL UNIQUE,
        is_enabled INTEGER NOT NULL DEFAULT 0 CHECK (is_enabled IN (0, 1)),
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
  }

  // Veritabanı Sürüm Değişiklikleri (Migration Mekanizması)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Gelecekteki şema güncellemeleri (v1 -> v2 vb.) bu blokta yönetilecektir.
  }

  // Veritabanını güvenli kapatma ve referansı sıfırlama
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null; // Bellek ve bağlantı sızıntısı önlenir
    }
  }
}