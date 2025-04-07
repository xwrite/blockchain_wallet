import 'dart:typed_data';

import 'package:blockchain_wallet/app_config.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';

///节点连接服务
class Web3Service extends GetxService {
  ///转账标准gas Limit
  final gasLimit = BigInt.from(21000);

  final _client = Web3Client(AppConfig.ethNetworkUrl, Client());

  Future<BigInt?> getBalance(String hexAddress) async {
    try {
      final address = EthereumAddress.fromHex(hexAddress);
      final amount = await _client.getBalance(address);
      return amount.getInWei;
    } catch (ex) {
      logger.w(ex);
      return null;
    }

  }

  Future<BigInt?> getGasPrice() async {
    try {
      final amount = await _client.getGasPrice();
      return amount.getInWei;
    } catch (ex) {
      logger.w(ex);
      return null;
    }
  }

  ///转账
  ///- returns 成功返回交易hash
  Future<String?> transfer({
    required Uint8List privateKey,
    required String receiveAddress,
    required BigInt gasPrice,
    required BigInt amount,
  }) async {
    try {
      final credentials = EthPrivateKey(privateKey);
      final chainId = await _client.getChainId();
      final txHash = await _client.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(receiveAddress),
          maxGas: gasLimit.toInt(),
          gasPrice: EtherAmount.fromBigInt(EtherUnit.wei, gasPrice),
          value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
        ),
        chainId: chainId.toInt(),
      );
      logger.d('sendTransaction: $txHash');

      //保存交易记录
      final txEntity = TransactionEntity(
        txHash: txHash,
        from: credentials.address.eip55With0x,
        to: receiveAddress,
        value: amount.toString(),
        gasPrice: gasPrice.toString(),
        status: 0,
        type: 0,
      );
      await G.db.transactionDao.save(txEntity);
      return txHash;
    } catch (ex) {
      logger.w(ex);
      return null;
    }
  }
}
