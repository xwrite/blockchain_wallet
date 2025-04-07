
import 'dart:typed_data';

import 'package:hex/hex.dart';

extension StringExtension on String{

  String toUriString({Map<String, dynamic /*String?|Iterable<String>*/>? queryParameters}){
    return Uri(path: this, queryParameters: queryParameters).toString();
  }

  /// 16进制字符串转为字节数组
  Uint8List toHexBytes(){
    return Uint8List.fromList(HEX.decode(this));
  }

}