import '../entity/transaction_entity.dart';

///交易记录 DAO
abstract class TransactionDao {

  ///创建表
  Future<void> createTable();

  ///插入或更新
  Future<void> insertOrUpdate(TransactionEntity entity);

  ///删除
  Future<void> deleteByTxHash(String txHash);

  ///删除所有数据
  Future<void> deleteAll();

  ///查询
  Future<TransactionEntity?> findByTxHash(String txHash);

  ///分页查询
  Future<List<TransactionEntity>> findPage({
    required int page,
    required int pageSize,
  });
}
