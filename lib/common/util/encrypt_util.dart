import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:blockchain_wallet/common/extension/byte_extension.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';

///加密工具类
class EncryptUtil {
  EncryptUtil._();

  /// 生成 256 位 AES 密钥（32字节）
  static Uint8List generateAesKey() {
    final key = SecureRandom('AES/CTR/AUTO-SEED-PRNG').nextBytes(32);
    return key;
  }

  /// 生成 16 字节 IV（CBC 模式必需）
  static Uint8List generateIv() {
    final iv = SecureRandom('AES/CTR/AUTO-SEED-PRNG').nextBytes(16);
    return iv;
  }

  ///AES加密(PKCS7填充)
  static Uint8List aesCbcEncrypt({
    required Uint8List data,
    required Uint8List key,
    required Uint8List iv,
  }) {
    // PKCS7 填充
    Uint8List padBytes(Uint8List data, int blockSize) {
      final padLength = blockSize - (data.length % blockSize);
      final padded = Uint8List(data.length + padLength)..setAll(0, data);
      padded.fillRange(data.length, padded.length, padLength);
      return padded;
    }

    // 创建加密器实例
    final aesCipher = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true 表示加密模式

    // 添加 PKCS7 填充
    final paddedData = padBytes(data, aesCipher.blockSize);

    // 分块加密
    final cipherText = Uint8List(paddedData.length);
    for (var offset = 0;
        offset < paddedData.length;
        offset += aesCipher.blockSize) {
      final block = paddedData.sublist(offset, offset + aesCipher.blockSize);
      final encryptedBlock = aesCipher.process(block);
      cipherText.setRange(offset, offset + aesCipher.blockSize, encryptedBlock);
    }

    return cipherText;
  }

  ///AES解密(PKCS7填充)
  static Uint8List aesCbcDecrypt({
    required Uint8List data,
    required Uint8List key,
    required Uint8List iv,
  }) {
    final aesCipher = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false 表示解密模式

    final decryptedData = Uint8List(data.length);
    for (var offset = 0; offset < data.length; offset += aesCipher.blockSize) {
      final block = data.sublist(offset, offset + aesCipher.blockSize);
      final decryptedBlock = aesCipher.process(block);
      decryptedData.setRange(
          offset, offset + aesCipher.blockSize, decryptedBlock);
    }

    // PKCS7 去填充
    Uint8List unpadBytes(Uint8List data) {
      final padLength = data.last;
      return data.sublist(0, data.length - padLength);
    }

    return unpadBytes(decryptedData);
  }


  /// AES-GCM 加密
  /// - data
  /// - key
  /// - nonce 推荐12字节
  /// - aad 附加认证数据
  /// - tagLength 认证标签长度（必须为128位）
  static Uint8List aesGcmEncrypt({
    required Uint8List data,
    required Uint8List key,
    required Uint8List nonce,
    Uint8List? aad,
    int tagLength = 16,
  }) {
    // 初始化加密器
    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true, // 加密模式
        AEADParameters(
          KeyParameter(key),
          tagLength * 8, // 转换为比特
          nonce,
          aad ?? Uint8List(0),
        ),
      );

    // 处理数据
    final cipherText = gcm.process(data);

    // 组合输出：密文 + 认证标签
    return Uint8List.fromList([...cipherText, ...gcm.mac]);
  }

  static Uint8List? aesGcmDecrypt({
    required Uint8List data,
    required Uint8List key,
    required Uint8List nonce,
    Uint8List? aad,
    int tagLength = 16,
  }) {
    try {
      // 分离 密文、认证标签
      final cipherText = data.sublist(0, data.length - tagLength);
      final receivedTag = data.sublist(cipherText.length);

      // 初始化解密器
      final gcm = GCMBlockCipher(AESEngine())
        ..init(
          false, // 解密模式
          AEADParameters(
            KeyParameter(key),
            tagLength * 8,
            nonce,
            aad ?? Uint8List(0),
          ),
        );

      // 解密并验证标签
      final decrypted = gcm.process(cipherText);

      // 安全比较认证标签（防时序攻击）
      if (!receivedTag.equals(gcm.mac)) {
        return null; // 认证失败
      }
      return decrypted;
    } catch (e) {
      return null;
    }
  }


  ///PBKDF2 派生密钥
  static Uint8List deriveKeyWithPBKDF2({
    required Uint8List password,
    required Uint8List salt,
    int iterations = 100000,
  }) {
    // 1. 配置 PBKDF2 参数
    final params = Pbkdf2Parameters(
      salt,
      iterations,
      32, // AES-256 需要 32 字节
    );

    // 2. 创建 HMAC-SHA256 伪随机函数
    final hmac = HMac(SHA256Digest(), 64); // SHA256 的块大小为 64 字节

    // 3. 初始化 PBKDF2 实例
    final pbkdf2 = PBKDF2KeyDerivator(hmac)..init(params);

    // 4. 执行密钥派生
    return pbkdf2.process(password);
  }

  ///生成随机密钥
  ///- length 密钥长度
  static Uint8List generateKey(int length) {
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
  static Uint8List deriveKeyWithArgon2({
    required Uint8List salt,
    required Uint8List password,
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

    return gen.process(password);
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
