import 'package:gankcamp_flutter/model/collection_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

const String _TABLE_NAME = 'collection';
const String COLUMN_ID = '_id';
const String COLUMN_TITLE = 'title';
const String COLUMN_URL = 'url';
const String COLUMN_TIME = 'time';

class CollectionDBManager {
  static final CollectionDBManager _instance = CollectionDBManager.internal();
  static Database _database;
  final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  factory CollectionDBManager() => _instance;

  CollectionDBManager.internal();

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initialize();
    return _database;
  }

  Future<Database> initialize() async {
    String databasesPath = await getDatabasesPath();
    return await openDatabase(
      join(databasesPath, 'collection.db'),
      version: 1,
      onCreate: (db, version) async {
        final createSqlStr =
            'create table $_TABLE_NAME ($COLUMN_ID integer primary key autoincrement,$COLUMN_TITLE text not null,$COLUMN_URL text not null,$COLUMN_TIME text not null)';
        print('createSqlStr：$createSqlStr');
        await db.execute(createSqlStr);
      },
    );
  }

  Future<CollectionInfo> add(CollectionInfo reqCollectionInfo) async {
    var dbClient = await db;
    // 判断是否已经存在该收藏，有则不再新增收藏
    CollectionInfo queryCollectionInfo = await getCollectionByTitleAndUrl(
        reqCollectionInfo.title, reqCollectionInfo.url);
    if (null == queryCollectionInfo) {
      reqCollectionInfo.time = _dateFormat.format(DateTime.now());
      reqCollectionInfo.id =
          await dbClient.insert(_TABLE_NAME, reqCollectionInfo.toMap());
    } else {
      reqCollectionInfo.id = queryCollectionInfo.id;
    }
    return reqCollectionInfo;
  }

  Future<List<CollectionInfo>> list() async {
    var dbClient = await db;
    List<Map<String, dynamic>> result =
        await dbClient.query(_TABLE_NAME, orderBy: '$COLUMN_ID desc');
    List<CollectionInfo> retCollectionInfo;
    if (null != result && result.isNotEmpty) {
      retCollectionInfo = [];
      result.forEach((v) => retCollectionInfo.add(CollectionInfo.fromMap(v)));
    }
    return retCollectionInfo;
  }

  Future<int> remove(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(_TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
  }

  Future<CollectionInfo> getCollectionByTitleAndUrl(
      String title, String url) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(_TABLE_NAME,
        where: '$COLUMN_TITLE = ? and $COLUMN_URL = ?',
        whereArgs: [title, url]);
    if (null != result && result.isNotEmpty) {
      return CollectionInfo.fromMap(result.first);
    }
    return null;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
