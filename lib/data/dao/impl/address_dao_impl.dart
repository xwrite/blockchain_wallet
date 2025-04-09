import 'package:blockchain_wallet/data/dao/address_dao.dart';
import 'package:blockchain_wallet/data/entity/address_entity.dart';
import 'package:sqflite/sqflite.dart';


///地址 DAO
class AddressDaoImpl extends AddressDao {
  static const _tableName = 'address';

  final Database _database;

  AddressDaoImpl(this._database);

  ///创建表
  @override
  Future<void> createTable(){
    return _database.execute('''
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

  @override
  Future<void> insertOrUpdate(AddressEntity entity) async {
    final results = await _database.query(_tableName,
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
      await _database.update(
          _tableName,
          {
            ...values,
            'createdAt': createdAt,
          },
          where: 'address=?',
          whereArgs: [entity.address]);
    } else {
      await _database.insert(_tableName, values);
    }
  }

  @override
  Future<void> deleteByAddress(String address) async {
    await _database
        .delete(_tableName, where: 'address = ?', whereArgs: [address]);
  }

  @override
  Future<List<AddressEntity>> findPage({
    required int page,
    required int pageSize,
  }) async {
    final results = await _database.query(
      _tableName,
      orderBy: 'createdAt desc',
      offset: (page - 1) * pageSize,
      limit: pageSize,
    );
    return results.map((e) => AddressEntity.fromJson(e)).toList();
  }

  @override
  Future<List<AddressEntity>> findAll() async {
    final results = await _database.query(
      _tableName,
      orderBy: 'createdAt desc',
    );
    return results.map((e) => AddressEntity.fromJson(e)).toList();
  }
}
