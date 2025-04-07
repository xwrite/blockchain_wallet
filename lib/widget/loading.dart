import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  const Loading._();

  static TransitionBuilder init({TransitionBuilder? builder}) {
    EasyLoading.instance
      ..contentPadding = XEdgeInsets(all: 24)
      ..indicatorSize = 48
      ..userInteractions = false
      ..dismissOnTap = true;
    return EasyLoading.init(builder: builder);
  }

  static Future<void> show({String? message, bool? dismissOnTap}) {
    return EasyLoading.show(status: message, dismissOnTap: dismissOnTap);
  }

  static Future<void> dismiss() async{
    return EasyLoading.dismiss();
  }

  static Future<R> asyncWrapper<R>(Future<R> Function() future) async{
    await show();
    final result = await future.call();
    await dismiss();
    return result;
  }

}