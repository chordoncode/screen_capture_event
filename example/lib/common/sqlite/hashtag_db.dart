import 'package:path/path.dart';
import 'package:grab_hashtag/common/sqlite/hashtag_table.dart';
import 'package:grab_hashtag/common/util/time_utils.dart';
import 'package:grab_hashtag/repositories/hashtag_repository.dart';
import 'package:sqflite/sqflite.dart';

/**
 * created_date/modified_date: millisSinceEpoch
 * We can get DateTime by DateTime.fromMillisecondsSinceEpoch(yourValue);
 */
class HashTagDb {
  static const String DB_NAME = 'grabtags_database.db';
  static const Map<HashTagTable, String> DDL = {
    HashTagRepository.TABLE: HashTagRepository.DDL
  };

  Database? _database;

  static final HashTagDb _instance = HashTagDb._internal();

  factory HashTagDb() {
    return _instance;
  }

  HashTagDb._internal();

  Future<Database> _init() async {
    //await _deleteDB_temp();

    return await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        return db.execute(DDL[HashTagRepository.TABLE]!);
      },
      version: 1,
    );
  }

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _init();
    return _database!;
  }

  Future<void> _deleteDB_temp() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_NAME);

    // Delete the database
    await deleteDatabase(path);
  }

  Future<int> insert(final HashTagTable table, final Map<String, dynamic> data) async {
    final Database db = await database;

    final int now = TimeUtils.nowForMillisecondsSinceEpoch();
    data['created_date'] = now;
    data['modified_date'] = now;

    return await db.insert(
      table.tableName(),
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(final HashTagTable table, final Map<String, dynamic> data, final String where, final List whereArgs) async {
    final Database db = await database;

    await db.update(
      table.tableName(),
      data,
      where: where, // "id = ?"
      whereArgs: whereArgs //[dog.id]
    );
  }

  Future<int> delete(final HashTagTable table, final String where, final List whereArgs) async {
    final Database db = await database;
    return await db.delete(
      table.tableName(),
      where: where,
      whereArgs: whereArgs
    );
  }

  Future<List<Map<String, dynamic>>> select(final HashTagTable table, {final String? where, final List? whereArgs, final String? orderBy}) async {
    final Database db = await database;
    return await db.query(
      table.tableName(),
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy
    );
  }

  Future<Map<String, dynamic>> selectOne(final HashTagTable table, {final String? where, final List? whereArgs, final String? orderBy}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        table.tableName(),
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy
    );
    return maps.first;
  }
}