import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/dao/transaction_dao.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;
  final Web3Provider _web3provider;

  TransactionRepository({
    required TransactionDao transactionDao,
    required Web3Provider web3provider,
  })  : _transactionDao = transactionDao,
        _web3provider = web3provider;

  ///插入或更新
  Future<void> saveTransaction(TransactionEntity entity) {
    return _transactionDao.insertOrUpdate(entity);
  }

  ///删除
  Future<void> deleteTransaction(String txHash) {
    return _transactionDao.deleteByTxHash(txHash);
  }

  ///获取交易
  Future<TransactionEntity?> getTransaction(String txHash) async{
    var entity = await _transactionDao.findByTxHash(txHash);
    if(entity == null || entity.status > 0){
      return entity;
    }
    final receipt = await _web3provider.getTransactionReceipt(txHash);
    if(receipt != null){
      entity = entity.copyWith(
        status: receipt.status == true ? 1 : 2,
        gasUsed: receipt.gasUsed?.toInt(),
        blockHash: receipt.blockHash,
        blockNumber: receipt.blockNum,
      );
      await _transactionDao.insertOrUpdate(entity);
    }
    return entity;
  }

  ///分页查询
  Future<List<TransactionEntity>> getTransactionPage({
    required int page,
    required int pageSize,
  }) {
    return _transactionDao.findPage(page: page, pageSize: pageSize);
  }
}
