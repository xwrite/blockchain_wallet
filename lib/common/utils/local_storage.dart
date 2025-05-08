import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _ApplyFunc<R> = Future<R> Function(SharedPreferences sp);

///本地存储
class LocalStorage{
  final String _prefix;
  LocalStorage(String name): _prefix = name, assert(name.isNotEmpty);

  Future<R> _execute<R>(_ApplyFunc<R> apply) async{
    final sp = await SharedPreferences.getInstance();
    return apply(sp);
  }

  String _makeKey(String key) => _prefix + key;

  Future<bool?> getBool(String key,{bool reload = false}) async{
    return _execute((sp) async{
      if(reload){
        await sp.reload();
      }
      return sp.getBool(_makeKey(key));
    });
  }

  Future<bool> setBool(String key, bool value) async{
    return _execute((sp) => sp.setBool(_makeKey(key), value));
  }

  Future<int?> getInt(String key, {bool reload = false}) async{
    return _execute((sp) async{
      if(reload){
        await sp.reload();
      }
      return sp.getInt(_makeKey(key));
    });
  }

  Future<bool> setInt(String key, int value) async{
    return _execute((sp) => sp.setInt(_makeKey(key), value));
  }

  Future<String?> getString(String key, {bool reload = false}) async{
    return _execute((sp) async{
      if(reload){
        await sp.reload();
      }
      return sp.getString(_makeKey(key));
    });
  }

  Future<bool> setString(String key, String value) async{
    return _execute((sp) => sp.setString(_makeKey(key), value));
  }

  Future<List<String>?> getStringList(String key, {bool reload = false}) async{
    return _execute((sp) async{
      if(reload){
        await sp.reload();
      }
      return sp.getStringList(_makeKey(key));
    });
  }

  Future<bool> setStringList(String key, List<String> value) async{
    return _execute((sp) => sp.setStringList(_makeKey(key), value));
  }

  Future<bool> remove(String key){
    return _execute((sp) => sp.remove(_makeKey(key)));
  }

  Future<Map<String,dynamic>?> getJson(String key, {bool reload = false}) async {
    final jsonStr = await getString(key, reload: reload);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try{
        return jsonDecode(jsonStr);
      }catch(ex){
        debugPrint('getJson error=$ex');
      }
    }
    return null;
  }

  Future<bool> setJson(String key, Map<String,dynamic> value) async {
    return setString(key, jsonEncode(value));
  }

  Future<List<Map<String,dynamic>>?> getJsonArray(String key, {bool reload = false}) async {
    final jsonStr = await getString(key, reload: reload);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try{
        final data = jsonDecode(jsonStr);
        if(data is List){
          return data.cast();
        }
        return [];
      }catch(ex){
        debugPrint('getJsonArray error=$ex');
      }
    }
    return null;
  }

  Future<bool> setJsonArray(String key, List<Map<String,dynamic>> value) async {
    return setString(key, jsonEncode(value));
  }

  Future<bool> clear(){
    return _execute((sp) async{
      final keys = sp.getKeys();
      for (var element in keys) {
        if(element.startsWith(_prefix)){
          await sp.remove(element);
        }
      }
      return true;
    });
  }

  Future<void> reload(){
    return _execute((sp) => sp.reload());
  }

}