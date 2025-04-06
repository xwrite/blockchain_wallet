
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'transaction_dao.dart';


///数据库
class AppDatabase {
  AppDatabase._();

  static final instance = AppDatabase._();
  late Database _database;
  late TransactionDao _transactionDao;
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
    }
    return _database;
  }

  ///数据库创建时，创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    await TransactionDao(db).createTable();
  }

  TransactionDao get transactionDao => _transactionDao;

}
