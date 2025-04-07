
import 'dart:typed_data';

extension Uint8ListExtension on Uint8List{

  /// 安全比较函数
  bool equals(Uint8List other) {
    if (length != other.length) return false;
    int result = 0;
    for (int i = 0; i < length; i++) {
      result |= this[i] ^ other[i];
    }
    return result == 0;
  }

}