
import 'package:blockchain_wallet/service/loading_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

mixin CubitLoadingMixin<State> on BlocBase<State>{

  Future<void> showLoading({String? message, bool? dismissOnTap}){
    return GetIt.I<LoadingService>().showLoading(message: message, dismissOnTap: dismissOnTap);
  }

  Future<void> dismissLoading(){
    return GetIt.I<LoadingService>().dismissLoading();
  }

  Future<void> showToast(String msg){
    return GetIt.I<LoadingService>().showToast(msg);
  }

  Future<void> dismissToast(){
    return GetIt.I<LoadingService>().dismissToast();
  }
}