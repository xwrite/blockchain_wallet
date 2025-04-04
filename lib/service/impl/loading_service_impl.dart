
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';

import '../loading_service.dart';


class LoadingServiceImpl extends LoadingService{

  @override
  Future<void> dismissLoading() {
    return Loading.dismiss();
  }

  @override
  Future<void> dismissToast() {
   return Toast.cancel();
  }

  @override
  Future<void> showLoading({String? message, bool? dismissOnTap}) {
    return Loading.show(message: message, dismissOnTap: dismissOnTap);
  }

  @override
  Future<void> showToast(String msg) {
    return Toast.cancel();
  }

}