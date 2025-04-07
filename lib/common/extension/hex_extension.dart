
import 'dart:typed_data';

import 'package:hex/hex.dart';

extension HexDecodeExtension on String{

  /// 16进制字符串转为字节数组
  Uint8List decodeHex(){
    return Uint8List.fromList(HEX.decode(this));
  }

}

extension HexEncodeExtension on Uint8List{
  /// 转为16进制字符串
  String encodeHex(){
    return HEX.encode(this);
  }
}