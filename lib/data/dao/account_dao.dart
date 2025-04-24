import '../entity/account_entity.dart';

///账户 DAO
abstract class AccountDao {

  ///创建表
  Future<void> createTable();

  ///添加或更新
  Future<void> insertOrUpdate(AccountEntity entity);

  ///删除
  Future<void> deleteByAddress(String address);

  ///获取
  Future<AccountEntity?> findByAddress(String address);

  ///分页查询
  Future<List<AccountEntity>> findPage({
    required int page,
    required int pageSize,
  });

  ///查询所有
  Future<List<AccountEntity>> findAll();
}
