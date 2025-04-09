import '../entity/address_entity.dart';

///地址 DAO
abstract class AddressDao {

  ///创建表
  Future<void> createTable();

  ///添加或更新
  Future<void> insertOrUpdate(AddressEntity entity);

  ///删除
  Future<void> deleteByAddress(String address);

  ///分页查询
  Future<List<AddressEntity>> findPage({
    required int page,
    required int pageSize,
  });

  ///查询所有
  Future<List<AddressEntity>> findAll();
}
