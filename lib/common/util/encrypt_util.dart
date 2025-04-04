import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';

class EncryptUtil {
  EncryptUtil._();

  ///生成随机盐
  static Uint8List generateSalt({int length = 32}) {
    // 初始化 Fortuna 随机数生成器
    final fortuna = FortunaRandom();
    final seedSource = Random.secure(); // 使用安全随机源播种
    final seed = Uint8List(32);
    for (int i = 0; i < seed.length; i++) {
      seed[i] = seedSource.nextInt(256);
    }
    fortuna.seed(KeyParameter(seed)); // 播种
    // 生成随机盐
    return fortuna.nextBytes(length);
  }

  ///argon2密钥生成
  ///- salt 加盐
  ///- password 密码
  ///- memoryPowerOf2 算法运行时所消耗的内存(2的16次方=64M)
  ///- iterations 迭代次数
  ///- desiredKeyLength 输出密钥长度（32字节=256位）
  static Uint8List argon2({
    required Uint8List salt,
    required String password,
    int memoryPowerOf2 = 16,
    int iterations = 2,
    int desiredKeyLength = 32,
  }) {
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      salt,
      version: Argon2Parameters.ARGON2_VERSION_10,
      desiredKeyLength: desiredKeyLength,
      iterations: iterations,
      memoryPowerOf2: memoryPowerOf2, //64M
    );

    final gen = Argon2BytesGenerator();
    gen.init(parameters);

    return gen.process(utf8.encode(password));
  }

  ///解析hex字符串为bytes
  static Uint8List fromHexString(String hexString) {
    return Uint8List.fromList(HEX.decode(hexString));
  }

  ///bytes转为hex字符串
  static String toHexString(Uint8List data) {
    return HEX.encode(data);
  }
}
