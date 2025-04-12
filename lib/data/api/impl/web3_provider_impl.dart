import 'dart:typed_data';
import 'package:blockchain_wallet/common/util/hex.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/data/entity/transaction_receipt_entity.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';
import '../web3_provider.dart';

///区块链网络通信
class Web3ProviderImpl extends Web3Provider {

  final Web3Client _client;

  Web3ProviderImpl({required Web3Client client}): _client = client;

  ///查询余额
  ///- address 钱包地址
  @override
  Future<BigInt?> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final amount = await _client.getBalance(ethAddress);
      return amount.getInWei;
    } catch (ex) {
      logger.w(ex);
      return null;
    }
  }

  ///查询当前网络gasPrice
  @override
  Future<BigInt?> getGasPrice() async{
    try {
      final amount = await _client.getGasPrice();
      return amount.getInWei;
    } catch (ex) {
      logger.w(ex);
      return null;
    }
  }

  ///发送交易
  ///- privateKey 发送地址私钥
  ///- toAddress 接收地址
  ///- gasPrice gas价格
  ///- gasLimit 最大gas用量
  ///- value 转账数量
  ///- returns 成功返回交易hash
  @override
  Future<String?> sendTransaction({
    required Uint8List privateKey,
    required String toAddress,
    required BigInt gasPrice,
    required BigInt gasLimit,
    required BigInt value,
  }) async{
    try {
      final chainId = await _client.getChainId();
      final txHash = await _client.sendTransaction(
        EthPrivateKey(privateKey),
        Transaction(
          to: EthereumAddress.fromHex(toAddress),
          maxGas: gasLimit.toInt(),
          gasPrice: EtherAmount.fromBigInt(EtherUnit.wei, gasPrice),
          value: EtherAmount.fromBigInt(EtherUnit.wei, value),
        ),
        chainId: chainId.toInt(),
      );
      logger.d('sendTransaction: $txHash');
      return txHash;
    } catch (ex) {
      logger.w(ex);
      return null;
    }
  }

  ///查询交易回执
  ///- txHash 交易哈希
  @override
  Future<TransactionReceiptEntity?> getTransactionReceipt(String txHash) async{
    try{
      final receipt = await _client.getTransactionReceipt(txHash);
      if(receipt != null){
        return TransactionReceiptEntity(
          txHash: txHash,
          status: receipt.status,
          gasUsed: receipt.gasUsed,
          blockHash: Hex.encodeWith0x(receipt.blockHash),
          blockNum: receipt.blockNumber.blockNum,
        );
      }
    }catch(ex){
      logger.w(ex);
    }
    return null;
  }

}