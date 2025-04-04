import 'dart:async';
import 'value_callback.dart';

class Observable<T, E> {
  final FutureOr<void> Function(ObservableEmitter<T, E> emitter) runnable;
  T? data;
  E? error;
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = false;

  Observable(this.runnable);

  void subscribe({
    ValueCallback<T>? onSuccess,
    ValueCallback<E>? onError,
    ValueCallback<bool>? onLoading,
  }) {
    runnable.call(ObservableEmitter<T, E>._(
      onSuccess: (data) {
        if(isSuccess){
          return;
        }
        this.data = data;
        isSuccess = true;
        onSuccess?.call(data);
        if(isLoading){
          isLoading = false;
          onLoading?.call(false);
        }
      },
      onError: (error) {
        if(isError){
          return;
        }
        this.error = error;
        isError = true;
        onError?.call(error);
        if(isLoading){
          isLoading = false;
          onLoading?.call(false);
        }
      },
      onLoading: (isLoading) {
        if(this.isLoading != isLoading){
          this.isLoading = isLoading;
          onLoading?.call(isLoading);
        }
      },
    ));
  }
}

class ObservableEmitter<T, E> {
  final ValueCallback<T> onSuccess;
  ValueCallback<E> onError;
  ValueCallback<bool> onLoading;

  ObservableEmitter._({
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  });
}
