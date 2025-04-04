import 'package:blockchain_wallet/common/observable.dart';
import 'package:blockchain_wallet/common/value_callback.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';

extension ObservableExtension<T,E> on Observable<T, E>{
  
  void subscribeUi({
    ValueCallback<T>? onSuccess,
    ValueCallback<E>? onError,
    ValueCallback<bool>? onLoading,
  }){
    subscribe(
      onSuccess: onSuccess,
      onError: onError ?? (error){
        if(error is String){
          Toast.show(error);
        }
      },
      onLoading: onLoading ?? (isLoading){
        if(isLoading){
          Loading.show();
        }else{
          Loading.dismiss();
        }
      },
    );
  }
}