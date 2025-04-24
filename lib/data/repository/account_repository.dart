import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/dao/account_dao.dart';
import 'package:blockchain_wallet/data/dao/transaction_dao.dart';
import 'package:blockchain_wallet/data/entity/account_entity.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';

class AccountRepository {
  final AccountDao _accountDao;

  AccountRepository({
    required AccountDao accountDao,
  })  : _accountDao = accountDao;

  ///插入或更新
  Future<void> saveAccount(AccountEntity entity) {
    return _accountDao.insertOrUpdate(entity);
  }

  ///删除
  Future<void> deleteAccount(String address) {
    return _accountDao.deleteByAddress(address);
  }

  ///获取
  Future<AccountEntity?> getAccount(String address) {
    return  _accountDao.findByAddress(address);
  }

  ///分页查询
  Future<List<AccountEntity>> getAccountPage({
    required int page,
    required int pageSize,
  }) {
    return _accountDao.findPage(page: page, pageSize: pageSize);
  }
}
