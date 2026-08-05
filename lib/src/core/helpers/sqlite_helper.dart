import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite database helper singleton
///
/// This class provides a wrapper around SQLite database with
/// advanced features like migrations, CRUD operations, and transactions.
///
/// Usage:
/// ```dart
/// final dbHelper = SQLiteHelper();
/// await dbHelper.init();
/// await dbHelper.insert('users', {'name': 'John', 'email': 'john@example.com'});
/// ```
class SQLiteHelper {
  /// Factory constructor returns singleton instance
  factory SQLiteHelper() => _instance;

  /// Private constructor for singleton pattern
  SQLiteHelper._privateConstructor();

  /// Singleton instance
  static final SQLiteHelper _instance = SQLiteHelper._privateConstructor();

  /// Database instance
  Database? _database;

  /// Logger instance
  final Logger _logger = Logger();

  /// Database configuration
  static const String _databaseName = 'app_database_test4.db';
  static const int _databaseVersion = 1;

  /// Initialize database
  Future<void> init() async {
    try {
      if (_database != null) return;

      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);

      try {
        _database = await openDatabase(
          path,
          version: _databaseVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade,
          onOpen: _onOpen,
        );
      } catch (e) {
        // If opening fails due to schema issues, recreate the database
        _logger.w('Database opening failed, attempting to recreate: $e');

        // Close and delete existing database
        try {
          await databaseFactory.deleteDatabase(path);
        } catch (deleteError) {
          _logger.w('Failed to delete existing database: $deleteError');
        }

        // Try to open again
        _database = await openDatabase(
          path,
          version: _databaseVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade,
          onOpen: _onOpen,
        );
      }

      _logger.i('SQLiteHelper initialized: $path');
    } catch (e) {
      _logger.e('Failed to initialize SQLite database', error: e);
      rethrow;
    }
  }

  /// Get database instance
  Future<Database> get database async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Favorites table to store ProductModel as JSON
      await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER UNIQUE NOT NULL,
          product_json TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      // Generic settings table
      // await db.execute('''
      //   CREATE TABLE settings (
      //     id INTEGER PRIMARY KEY AUTOINCREMENT,
      //     key TEXT UNIQUE NOT NULL,
      //     value TEXT NOT NULL,
      //     type TEXT NOT NULL,
      //     created_at TEXT NOT NULL,
      //     updated_at TEXT NOT NULL
      //   )
      // ''');

      _logger.i('Generic database tables created successfully');
    } catch (e) {
      _logger.e('Failed to create database tables', error: e);
      rethrow;
    }
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      _logger.i('Upgrading database from version $oldVersion to $newVersion');

      // Add migration steps here when needed
      // if (oldVersion < 2) {
      //   // Add future migration logic here
      // }

      // Add more migration steps as needed
    } catch (e) {
      _logger.e('Failed to upgrade database', error: e);
      rethrow;
    }
  }

  /// Handle database downgrades
  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    try {
      _logger.w('Downgrading database from version $oldVersion to $newVersion');
      // Handle downgrade logic if needed
    } catch (e) {
      _logger.e('Failed to downgrade database', error: e);
      rethrow;
    }
  }

  /// Handle database open
  Future<void> _onOpen(Database db) async {
    try {
      _logger.d('Database opened successfully');
    } catch (e) {
      _logger.e('Failed to handle database open', error: e);
      rethrow;
    }
  }

  // CRUD Operations

  /// Insert a record
  Future<int> insert(
    String table,
    Map<String, dynamic> data, {
    bool addTimestamps = true,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await database;

      if (addTimestamps) {
        // Add timestamps
        final now = DateTime.now().toIso8601String();
        data['created_at'] = now;
        data['updated_at'] = now;
      }

      final id = await db.insert(
        table,
        data,
        conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace,
      );
      _logger.d('Inserted record in $table with ID: $id');
      return id;
    } catch (e) {
      _logger.e('Failed to insert record in $table', error: e);
      rethrow;
    }
  }

  /// Insert multiple records in a transaction
  Future<List<int>> insertBatch(
    String table,
    List<Map<String, dynamic>> dataList, {
    bool addTimestamps = true,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await database;
      final ids = <int>[];

      await db.transaction((txn) async {
        for (final data in dataList) {
          if (addTimestamps) {
            // Add timestamps
            final now = DateTime.now().toIso8601String();
            data['created_at'] = now;
            data['updated_at'] = now;
          }

          final id = await txn.insert(
            table,
            data,
            conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace,
          );
          ids.add(id);
        }
      });

      _logger.d('Batch inserted ${dataList.length} records in $table');
      return ids;
    } catch (e) {
      _logger.e('Failed to batch insert records in $table', error: e);
      rethrow;
    }
  }

  /// Query records
  Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await database;
      final results = await db.query(
        table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      _logger.d('Queried $table: ${results.length} results');
      return results;
    } catch (e) {
      _logger.e('Failed to query $table', error: e);
      rethrow;
    }
  }

  /// Query single record
  Future<Map<String, dynamic>?> queryFirst(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    try {
      final results = await query(
        table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: 1,
      );

      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      _logger.e('Failed to query first record from $table', error: e);
      rethrow;
    }
  }

  /// Update records
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
    bool addTimestamps = true,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await database;

      if (addTimestamps) {
        // Add updated timestamp
        data['updated_at'] = DateTime.now().toIso8601String();
      }

      final count = await db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );

      _logger.d('Updated $count records in $table');
      return count;
    } catch (e) {
      _logger.e('Failed to update records in $table', error: e);
      rethrow;
    }
  }

  /// Delete records
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      final count = await db.delete(table, where: where, whereArgs: whereArgs);

      _logger.d('Deleted $count records from $table');
      return count;
    } catch (e) {
      _logger.e('Failed to delete records from $table', error: e);
      rethrow;
    }
  }

  /// Execute raw SQL query
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    try {
      final db = await database;
      final results = await db.rawQuery(sql, arguments);
      _logger.d('Raw query executed: ${results.length} results');
      return results;
    } catch (e) {
      _logger.e('Failed to execute raw query: $sql', error: e);
      rethrow;
    }
  }

  /// Execute raw SQL command
  Future<void> rawExecute(String sql, [List<dynamic>? arguments]) async {
    try {
      final db = await database;
      await db.execute(sql, arguments);
      _logger.d('Raw command executed: $sql');
    } catch (e) {
      _logger.e('Failed to execute raw command: $sql', error: e);
      rethrow;
    }
  }

  /// Execute multiple operations in a transaction
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    try {
      final db = await database;
      final result = await db.transaction(action);
      _logger.d('Transaction completed successfully');
      return result;
    } catch (e) {
      _logger.e('Transaction failed', error: e);
      rethrow;
    }
  }

  /// Get table row count
  Future<int> getCount(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
        whereArgs,
      );

      return (result.first['count'] as int?) ?? 0;
    } catch (e) {
      _logger.e('Failed to get count from $table', error: e);
      return 0;
    }
  }

  /// Check if table exists
  Future<bool> tableExists(String tableName) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName],
      );

      return result.isNotEmpty;
    } catch (e) {
      _logger.e('Failed to check if table exists: $tableName', error: e);
      return false;
    }
  }

  /// Clear all data from table
  Future<void> clearTable(String table) async {
    try {
      final db = await database;
      await db.delete(table);
      _logger.i('Cleared all data from $table');
    } catch (e) {
      _logger.e('Failed to clear table: $table', error: e);
      rethrow;
    }
  }

  /// Close database connection
  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        _logger.i('Database connection closed');
      }
    } catch (e) {
      _logger.e('Failed to close database', error: e);
    }
  }

  /// Delete database file
  Future<void> deleteDatabase() async {
    try {
      if (_database != null) {
        await close();
      }

      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);
      await databaseFactory.deleteDatabase(path);

      _logger.i('Database deleted: $path');
    } catch (e) {
      _logger.e('Failed to delete database', error: e);
      rethrow;
    }
  }

  /// Recreate database with updated schema
  Future<void> recreateDatabase() async {
    try {
      _logger.i('Recreating database with updated schema');

      // Close existing database
      await close();

      // Delete existing database
      await deleteDatabase();

      // Initialize new database
      await init();

      _logger.i('Database recreated successfully');
    } catch (e) {
      _logger.e('Failed to recreate database', error: e);
      rethrow;
    }
  }
}
