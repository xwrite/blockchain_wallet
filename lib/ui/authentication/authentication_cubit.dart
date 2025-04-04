import 'package:blockchain_wallet/common/observable.dart';
import 'package:blockchain_wallet/service/authentication_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState());

  void togglePasswordVisible(){
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void togglePasswordAgainVisible(){
    emit(state.copyWith(isPasswordAgainVisible: !state.isPasswordAgainVisible));
  }

  void changePassword(String password){
    emit(state.copyWith(password: password));
  }

  void changePasswordAgain(String passwordAgain){
    emit(state.copyWith(passwordAgain: passwordAgain));
  }

  Observable<void, String> confirm() {
    return Observable<void,String>((emitter) async{
      final password = state.password.trim();
      final passwordAgain = state.passwordAgain.trim();
      if(password.isEmpty){
        emitter.onError('请输入密码');
        return;
      }
      if(passwordAgain.isEmpty){
        emitter.onError('请再次输入密码');
        return;
      }
      if(password != passwordAgain){
        emitter.onError('两次密码输入不一致');
        return;
      }
      emitter.onLoading(true);
      await GetIt.I<AuthenticationService>().setPassword(password);
      emitter.onSuccess(null);
    });
  }

  Observable<void, String> verifyPassword(){
    return Observable<void,String>((emitter) async{
      final password = state.password.trim();
      if(password.isEmpty){
        emitter.onError('请输入密码');
        return;
      }
      emitter.onLoading(true);
      final result = await GetIt.I<AuthenticationService>().verifyPassword(password);
      if(result){
        emitter.onSuccess(null);
      }else{
        emitter.onError('密码错误');
      }
    });
  }

}
