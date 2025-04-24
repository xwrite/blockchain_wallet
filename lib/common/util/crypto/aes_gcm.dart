import 'dart:math';
import 'dart:typed_data';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:pointycastle/export.dart';

///AES/GCM(Pbkdf2将简单密码派生安全密钥)
class AesGcm {
  AesGcm._();

  static const ALGORITHM_NONCE_SIZE = 12; // bytes
  static const ALGORITHM_TAG_SIZE = 16; // bytes
  static const ALGORITHM_KEY_SIZE = 32; // bytes
  static const PBKDF2_PRF_DIGEST = 'SHA-256/HMAC/PBKDF2';
  static const PBKDF2_SALT_SIZE = 16; // bytes
  static const PBKDF2_ITERATIONS = 10000; //32767

  ///加密
  ///- passphrase 密码
  ///- plaintext 密码
  ///- aad 关联数据
  static Uint8List encrypt({
    required Uint8List passphrase,
    required Uint8List plaintext,
    Uint8List? aad,
  }) {
    // Derive random salt and nonce
    final rnd = _getSecureRandom();
    final salt = rnd.nextBytes(PBKDF2_SALT_SIZE);
    final nonce = rnd.nextBytes(ALGORITHM_NONCE_SIZE);

    // PBKDF2 密钥派生
    final key = _generateKey(salt, passphrase);

    // AES/GCM 加密
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(key),
          ALGORITHM_TAG_SIZE * 8,
          nonce,
          aad ?? Uint8List(0),
        ),
      );
    final ciphertextTag = cipher.process(plaintext);

    return Uint8List.fromList(salt + nonce + ciphertextTag);
  }

  ///解密
  ///- passphrase 密码
  ///- encryptedData 加密数据
  ///- aad 关联数据
  static Uint8List? decrypt({
    required Uint8List passphrase,
    required Uint8List encryptedData,
    Uint8List? aad,
  }) {
    try{
      // 拆分出 salt, nonce 和 ciphertext|tag
      final salt = encryptedData.sublist(0, PBKDF2_SALT_SIZE);
      final nonce = encryptedData.sublist(
          PBKDF2_SALT_SIZE, PBKDF2_SALT_SIZE + ALGORITHM_NONCE_SIZE);
      final ciphertextTag =
      encryptedData.sublist(PBKDF2_SALT_SIZE + ALGORITHM_NONCE_SIZE);

      // PBKDF2 密钥派生
      final key = _generateKey(salt, passphrase);

      // AES/GCM 解密
      final cipher = GCMBlockCipher(AESEngine())
        ..init(
          false,
          AEADParameters(
            KeyParameter(key),
            ALGORITHM_TAG_SIZE * 8,
            nonce,
            aad ?? Uint8List(0),
          ),
        );

      return cipher.process(ciphertextTag);
    }catch(ex){
      logger.w('aes解密失败，$ex');
      return null;
    }
  }

  ///随机数
  static SecureRandom _getSecureRandom() {
    final seed = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return FortunaRandom()..seed(KeyParameter(Uint8List.fromList(seed)));
  }

  ///PBKDF2派生安全密钥
  static Uint8List _generateKey(Uint8List salt, Uint8List passphrase) {
    final derivator = KeyDerivator(PBKDF2_PRF_DIGEST);
    final pbkdf2Params =
        Pbkdf2Parameters(salt, PBKDF2_ITERATIONS, ALGORITHM_KEY_SIZE);
    derivator.init(pbkdf2Params);
    return derivator.process(passphrase);
  }
}
