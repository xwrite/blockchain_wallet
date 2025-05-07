import '../entity/account_entity.dart';

///账户 DAO
abstract class AccountDao {

  ///创建表
  Future<void> createTable();

  ///添加或更新
  Future<void> insertOrUpdate(AccountEntity entity);

  ///删除
  Future<void> deleteByAddress(String address);

  ///删除所有数据
  Future<void> deleteAll();

  ///获取
  Future<AccountEntity?> findByAddress(String address);

  ///查询选择的账户
  Future<AccountEntity?> findSelected();

  ///设置选中的账户
  Future<void> updateSelectedByAddress(String address);

  ///分页查询
  Future<List<AccountEntity>> findPage({
    required int page,
    required int pageSize,
  });

  ///查询所有
  Future<List<AccountEntity>> findAll();


}
