library;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the LocalDatabase singleton.
final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  throw UnimplementedError('localDatabaseProvider must be overridden in main');
});

/// Core service for managing the SQLite database instance and schema.
class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('drivewise.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS question_mastery(
              question_id TEXT PRIMARY KEY,
              mastery_level INTEGER NOT NULL,
              consecutive_correct INTEGER NOT NULL,
              last_answered_at INTEGER NOT NULL,
              FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
            )
          ''');
        }
        if (oldVersion < 3) {
          // 1. Create states table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS states(
              state_id TEXT PRIMARY KEY,
              state_code TEXT NOT NULL,
              state_name TEXT NOT NULL,
              abbreviation TEXT NOT NULL,
              licensing_authority TEXT,
              official_website TEXT,
              handbook_source TEXT,
              content_version TEXT,
              last_verified INTEGER,
              status TEXT NOT NULL
            )
          ''');

          // 2. Create sources table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sources(
              source_id TEXT PRIMARY KEY,
              state_id TEXT NOT NULL,
              organization TEXT NOT NULL,
              title TEXT NOT NULL,
              url TEXT,
              document_version TEXT,
              publication_date INTEGER,
              last_updated INTEGER,
              source_type TEXT NOT NULL,
              last_verified INTEGER,
              status TEXT NOT NULL,
              FOREIGN KEY (state_id) REFERENCES states (state_id) ON DELETE CASCADE
            )
          ''');

          // 3. Alter questions table
          await db.execute('ALTER TABLE questions ADD COLUMN state_id TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN subcategory_id TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN difficulty TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN rule_id TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN source_id TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN source_section TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN source_page TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN source_version TEXT');
          await db.execute('ALTER TABLE questions ADD COLUMN last_verified INTEGER');
          await db.execute('ALTER TABLE questions ADD COLUMN verification_status TEXT');

          // 4. Alter road_signs table
          await db.execute('ALTER TABLE road_signs ADD COLUMN state_id TEXT');
          await db.execute('ALTER TABLE road_signs ADD COLUMN source_id TEXT');
          await db.execute('ALTER TABLE road_signs ADD COLUMN source_section TEXT');
          await db.execute('ALTER TABLE road_signs ADD COLUMN source_page TEXT');
          await db.execute('ALTER TABLE road_signs ADD COLUMN version TEXT');
          await db.execute('ALTER TABLE road_signs ADD COLUMN last_verified INTEGER');
        }
        if (oldVersion < 4) {
          // Alter test_history to scope by state
          await db.execute('ALTER TABLE test_history ADD COLUMN state_id TEXT');
          
          // Safely assign legacy mock tests to us_generic
          await db.execute("UPDATE test_history SET state_id = 'us_generic' WHERE state_id IS NULL");
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // States Table
    await db.execute('''
      CREATE TABLE states(
        state_id TEXT PRIMARY KEY,
        state_code TEXT NOT NULL,
        state_name TEXT NOT NULL,
        abbreviation TEXT NOT NULL,
        licensing_authority TEXT,
        official_website TEXT,
        handbook_source TEXT,
        content_version TEXT,
        last_verified INTEGER,
        status TEXT NOT NULL
      )
    ''');

    // Sources Table
    await db.execute('''
      CREATE TABLE sources(
        source_id TEXT PRIMARY KEY,
        state_id TEXT NOT NULL,
        organization TEXT NOT NULL,
        title TEXT NOT NULL,
        url TEXT,
        document_version TEXT,
        publication_date INTEGER,
        last_updated INTEGER,
        source_type TEXT NOT NULL,
        last_verified INTEGER,
        status TEXT NOT NULL,
        FOREIGN KEY (state_id) REFERENCES states (state_id) ON DELETE CASCADE
      )
    ''');

    // Categories Table
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Questions Table
    await db.execute('''
      CREATE TABLE questions(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        text TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_index INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        image_url TEXT,
        state_id TEXT,
        subcategory_id TEXT,
        difficulty TEXT,
        rule_id TEXT,
        source_id TEXT,
        source_section TEXT,
        source_page TEXT,
        source_version TEXT,
        last_verified INTEGER,
        verification_status TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // User Progress (Tracking individual answers)
    await db.execute('''
      CREATE TABLE user_progress(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        answered_at INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');

    // Question Mastery (Tracking overall mastery level per question)
    // mastery_level: 0=New, 1=Learning, 2=Improving, 3=Mastered
    await db.execute('''
      CREATE TABLE IF NOT EXISTS question_mastery(
        question_id TEXT PRIMARY KEY,
        mastery_level INTEGER NOT NULL,
        consecutive_correct INTEGER NOT NULL,
        last_answered_at INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');

    // Bookmarks
    await db.execute('''
      CREATE TABLE bookmarks(
        question_id TEXT PRIMARY KEY,
        added_at INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');

    // Test History
    await db.execute('''
      CREATE TABLE test_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        time_used_seconds INTEGER NOT NULL,
        is_passed INTEGER NOT NULL,
        completed_at INTEGER NOT NULL,
        state_id TEXT
      )
    ''');

    // Road Signs
    await db.execute('''
      CREATE TABLE road_signs(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        meaning TEXT NOT NULL,
        action_required TEXT NOT NULL,
        example_situation TEXT NOT NULL,
        icon_data_code INTEGER NOT NULL,
        color_hex INTEGER NOT NULL,
        shape_index INTEGER NOT NULL,
        state_id TEXT,
        source_id TEXT,
        source_section TEXT,
        source_page TEXT,
        version TEXT,
        last_verified INTEGER
      )
    ''');

    // Favorite Signs
    await db.execute('''
      CREATE TABLE favorite_signs(
        sign_id TEXT PRIMARY KEY,
        added_at INTEGER NOT NULL,
        FOREIGN KEY (sign_id) REFERENCES road_signs (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Wipes all user-generated data. Used for the Reset Progress action.
  Future<void> clearUserData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('user_progress');
      await txn.delete('question_mastery');
      await txn.delete('bookmarks');
      await txn.delete('test_history');
      await txn.delete('favorite_signs');
    });
  }
}
