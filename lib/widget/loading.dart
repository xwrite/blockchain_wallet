import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  const Loading._();

  static TransitionBuilder init({TransitionBuilder? builder}) {
    EasyLoading.instance
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

  static Future<R> asyncWrapper<R>(Future<R> future) async{
    await show();
    final result = await future;
    await dismiss();
    return result;
  }

}