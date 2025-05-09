import 'package:blockchain_wallet/data/dao/account_dao.dart';
import 'package:blockchain_wallet/data/entity/account_entity.dart';
import 'package:sqflite/sqflite.dart';

///账户 DAO
class AccountDaoImpl extends AccountDao {
  static const _tableName = 'table_account';

  final Database _database;

  AccountDaoImpl(this._database);

  ///创建表
  @override
  Future<void> createTable() {
    return _database.execute('''
    CREATE TABLE IF NOT EXISTS "$_tableName" (
      "address"	TEXT NOT NULL,
      "coin"	INTEGER NOT NULL,
      "index"	INTEGER NOT NULL,
      "selected"	INTEGER NOT NULL,
      "createdAt"	INTEGER NOT NULL,
      "updatedAt"	INTEGER NOT NULL,
      PRIMARY KEY("address")
    );
    ''');
  }

  @override
  Future<void> insertOrUpdate(AccountEntity entity) async {
    final results = await _database.query(_tableName,
        where: 'address=?', whereArgs: [entity.address], limit: 1, offset: 0);
    final values = {
      'address': entity.address,
      'coin': entity.coin,
      'index': entity.index,
      'selected': entity.selected,
      'createdAt': entity.createdAt.millisecondsSinceEpoch,
      'updatedAt': entity.updatedAt.millisecondsSinceEpoch,
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
  Future<List<AccountEntity>> findPage({
    required int page,
    required int pageSize,
  }) async {
    final results = await _database.query(
      _tableName,
      orderBy: 'createdAt desc',
      offset: (page - 1) * pageSize,
      limit: pageSize,
    );
    return results.map((e) => AccountEntity.fromJson(e)).toList();
  }

  @override
  Future<List<AccountEntity>> findAll() async {
    final results = await _database.query(
      _tableName,
      orderBy: 'createdAt desc',
    );
    return results.map((e) => AccountEntity.fromJson(e)).toList();
  }

  @override
  Future<AccountEntity?> findByAddress(String address) async {
    final results = await _database.query(
      _tableName,
      where: 'address=?',
      whereArgs: [address],
      limit: 1,
      offset: 0,
    );
    if (results.isNotEmpty) {
      return AccountEntity.fromJson(results.first);
    } else {
      return null;
    }
  }

  @override
  Future<AccountEntity?> findSelected() async {
    final results = await _database.query(
      _tableName,
      where: 'selected=?',
      whereArgs: [1],
      limit: 1,
      offset: 0,
    );
    if (results.isNotEmpty) {
      return AccountEntity.fromJson(results.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateSelectedByAddress(String address) async {
    await _database.transaction((txn) async {
      txn.update(
        _tableName,
        {'selected': 0},
        where: 'address != ?',
        whereArgs: [address],
      );
      txn.update(
        _tableName,
        {'selected': 1},
        where: 'address = ?',
        whereArgs: [address],
      );
    });
  }

  @override
  Future<void> deleteAll() async {
    await _database.transaction((txn) => txn.delete(_tableName));
  }

}
