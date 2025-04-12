import 'dart:typed_data';

import 'package:hex/hex.dart';

class Hex{
  Hex._();

  static String encode(Uint8List data){
    return HEX.encode(data);
  }

  static String encodeWith0x(Uint8List data){
    return '0x${encode(data)}';
  }

  static Uint8List decode(String data){
    return Uint8List.fromList(HEX.decode(data));
  }
}