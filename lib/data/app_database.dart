
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dao/address_dao.dart';
import 'dao/transaction_dao.dart';


///数据库
class AppDatabase {
  AppDatabase._();
  factory AppDatabase() => _instance ??= AppDatabase._();

  static AppDatabase? _instance;
  late Database _database;
  late TransactionDao _transactionDao;
  late AddressDao _addressDao;
  var _isInitialize = false;

  ///初始化数据库
  Future<Database> initialize() async {
    if(!_isInitialize){
      _isInitialize = true;
      final dir = await getDatabasesPath();
      final path = join(dir, 'app.db');
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);

      //init dao
      _transactionDao = TransactionDao(_database);
      _addressDao = AddressDao(_database);
    }
    return _database;
  }

  ///数据库创建时，创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    await TransactionDao.createTable(db);
    await AddressDao.createTable(db);
  }

  TransactionDao get transactionDao => _transactionDao;

  AddressDao get addressDao => _addressDao;

  ///删除数据库
  Future<void> delete() {
    return deleteDatabase(_database.path);
  }
}
