import 'package:sqflite/sqflite.dart';

import '../entity/address_entity.dart';


///地址 DAO
class AddressDao {
  static const _tableName = 'address';

  final Database database;

  AddressDao(this.database);

  ///创建表
  static Future<void> createTable(Database db){
    return db.execute('''
    CREATE TABLE IF NOT EXISTS "$_tableName" (
      "address"	TEXT NOT NULL,
      "path"	TEXT NOT NULL,
      "index"	INTEGER NOT NULL,
      "selected"	INTEGER NOT NULL,
      "createdAt"	INTEGER NOT NULL,
      "updatedAt"	INTEGER NOT NULL,
      PRIMARY KEY("address")
    );
    ''');
  }

  Future<void> save(AddressEntity entity) async {
    final results = await database.query(_tableName,
        where: 'address=?', whereArgs: [entity.address], limit: 1, offset: 0);
    final values = {
      'address': entity.address,
      'path': entity.path,
      'index': entity.index,
      'selected': entity.selected,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    if (results.isNotEmpty) {
      final createdAt = results.first['createdAt'];
      await database.update(
          _tableName,
          {
            ...values,
            'createdAt': createdAt,
          },
          where: 'address=?',
          whereArgs: [entity.address]);
    } else {
      await database.insert(_tableName, values);
    }
  }

  Future<void> delete(String address) async {
    await database
        .delete(_tableName, where: 'address = ?', whereArgs: [address]);
  }

  Future<List<AddressEntity>> list({
    required int page,
    required int pageSize,
  }) async {
    final results = await database.query(
      _tableName,
      orderBy: 'createdAt desc',
      offset: (page - 1) * pageSize,
      limit: pageSize,
    );
    return results.map((e) => AddressEntity.fromJson(e)).toList();
  }
}
