import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:blockchain_wallet/common/util/encrypt_util.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/api.dart';

void main(){
  testSha256();
}


void testSha256(){
  final sha256 = Digest('SHA-256');
  final out = sha256.process(utf8.encode('HELLO'));
  final hex = HEX.encode(out);
  print(hex);
}
