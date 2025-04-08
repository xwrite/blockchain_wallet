import 'package:sqflite/sqflite.dart';

import '../entity/transaction_entity.dart';

///交易记录 DAO
class TransactionDao {
  static const _tableName = 'transaction';

  final Database database;

  TransactionDao(this.database);

  ///创建表
  static Future<void> createTable(Database db) {
    return db.execute('''
    CREATE TABLE IF NOT EXISTS"$_tableName" (
      "txHash"	TEXT NOT NULL,
      "from"	TEXT NOT NULL,
      "to"	TEXT NOT NULL,
      "value"	TEXT NOT NULL,
      "gasPrice"	TEXT NOT NULL,
      "gasUsed"	INTEGER,
      "blockHash"	TEXT,
      "blockNumber"	INTEGER,
      "status"	INTEGER NOT NULL,
      "type"	INTEGER NOT NULL,
      "createdAt"	INTEGER NOT NULL,
      "updatedAt"	INTEGER NOT NULL,
      PRIMARY KEY("txHash")
    );
    ''');
  }

  Future<void> insertOrUpdate(TransactionEntity entity) async {
    final oldEntity = await findByTxHash(entity.txHash);
    final values = {
      'txHash': entity.txHash,
      'from': entity.from,
      'to': entity.to,
      'value': entity.value,
      'gasPrice': entity.gasPrice,
      'gasUsed': entity.gasUsed,
      'blockHash': entity.blockHash,
      'blockNumber': entity.blockNumber,
      'status': entity.status,
      'type': entity.type,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    if (oldEntity != null) {
      await database.update(
          _tableName,
          {
            ...values,
            'createdAt': oldEntity.createdAt,
          },
          where: 'txHash=?',
          whereArgs: [entity.txHash]);
    } else {
      await database.insert(_tableName, values);
    }
  }

  Future<void> deleteByTxHash(String txHash) async {
    await database.delete(_tableName, where: 'txHash = ?', whereArgs: [txHash]);
  }

  Future<TransactionEntity?> findByTxHash(String txHash) async {
    final results = await database.query(
      _tableName,
      where: 'txHash=?',
      whereArgs: [txHash],
      limit: 1,
      offset: 0,
    );
    if(results.isNotEmpty){
      return TransactionEntity.fromJson(results.first);
    }else{
      return null;
    }
  }

  Future<List<TransactionEntity>> findPage({
    required int page,
    required int pageSize,
  }) async {
    final results = await database.query(
      _tableName,
      orderBy: 'createdAt desc',
      offset: (page - 1) * pageSize,
      limit: pageSize,
    );
    return results.map((e) => TransactionEntity.fromJson(e)).toList();
  }
}
