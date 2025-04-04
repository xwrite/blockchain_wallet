
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';

abstract class LoadingService{
  Future<void> showLoading({String? message, bool? dismissOnTap});
  Future<void> dismissLoading();
  Future<void> showToast(String msg);
  Future<void> dismissToast();
}
