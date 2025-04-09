
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/impl/address_dao_impl.dart';
import 'dao/impl/transaction_dao_impl.dart';


///数据库
class AppDatabase {
  const AppDatabase._(this._database);

  final Database _database;

  ///初始化数据库
  static Future<AppDatabase> create() async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'app.db');
    final database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return AppDatabase._(database);
  }

  ///数据库创建时，创建数据库表
  static Future<void> _onCreate(Database db, int version) async {
    await TransactionDaoImpl(db).createTable();
    await AddressDaoImpl(db).createTable();
  }

  ///创建dao
  T createDao<T>(T Function(Database db) factory){
    return factory.call(_database);
  }

  ///删除数据库
  Future<void> delete() {
    return deleteDatabase(_database.path);
  }
}
