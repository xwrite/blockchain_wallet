
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:flutter/services.dart';

extension StringExtension on String{

  String toUriString({Map<String, dynamic /*String?|Iterable<String>*/>? queryParameters}){
    return Uri(path: this, queryParameters: queryParameters).toString();
  }

  ///复制当前文本
  Future<void> copy({String? msg}) async{
    if(isNotEmpty){
      await Clipboard.setData(ClipboardData(text: this));
      Toast.show(msg ?? '复制成功');
    }
  }

}