import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:sqflite/sqflite.dart';
import '../transaction_dao.dart';

///交易记录 DAO
class TransactionDaoImpl extends TransactionDao {
  static const _tableName = 'table_transaction';

  final Database _database;

  TransactionDaoImpl(this._database);

  ///创建表
  @override
  Future<void> createTable() {
    return _database.execute('''
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

  @override
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
      await _database.update(
          _tableName,
          {
            ...values,
            'createdAt': oldEntity.createdAt,
          },
          where: 'txHash=?',
          whereArgs: [entity.txHash]);
    } else {
      await _database.insert(_tableName, values);
    }
  }

  @override
  Future<void> deleteByTxHash(String txHash) async {
    await _database.delete(_tableName, where: 'txHash = ?', whereArgs: [txHash]);
  }

  @override
  Future<TransactionEntity?> findByTxHash(String txHash) async {
    final results = await _database.query(
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

  @override
  Future<List<TransactionEntity>> findPage({
    required int page,
    required int pageSize,
  }) async {
    final results = await _database.query(
      _tableName,
      orderBy: 'createdAt desc',
      offset: (page - 1) * pageSize,
      limit: pageSize,
    );
    return results.map((e) => TransactionEntity.fromJson(e)).toList();
  }
}
