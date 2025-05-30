

import 'dart:async';

import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:flutter/foundation.dart';

typedef CommandAction0<T> = FutureOr<Result<T>> Function();
typedef CommandAction1<T, A> = FutureOr<Result<T>> Function(A args);

abstract class Command<T> extends ChangeNotifier{

  bool _running = false;

  bool get running => _running;

  Result<T>? _result;

  Result<T>? get result => _result;

  bool get error => _result is Error;

  bool get completed => _result is Ok;


  void clear(){
    _result = null;
    notifyListeners();
  }

  FutureOr<void> _execute(CommandAction0<T> action) async{
    if(_running){
      return;
    }

    _running = true;
    _result = null;
    notifyListeners();

    try{
      _result = await action();
    }finally{
      _running = false;
      notifyListeners();
    }

  }
}

class Command0<T> extends Command<T>{

  final CommandAction0<T> _action;
  Command0(this._action);

  FutureOr<void> execute(){
    return _execute(_action);
  }

}

class Command1<T, A> extends Command<T>{

  final CommandAction1<T, A> _action;
  Command1(this._action);

  FutureOr<void> execute(A args){
    return _execute(() => _action(args));
  }

}