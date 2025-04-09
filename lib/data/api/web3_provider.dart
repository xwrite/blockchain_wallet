import 'dart:typed_data';
import 'package:blockchain_wallet/data/entity/transaction_receipt_entity.dart';

///区块链网络通信
abstract class Web3Provider{

  ///查询余额
  ///- address 钱包地址
  Future<BigInt?> getBalance(String address);

  ///查询当前网络gasPrice
  Future<BigInt?> getGasPrice();

  ///发送交易
  ///- privateKey 发送地址私钥
  ///- toAddress 接收地址
  ///- gasPrice gas价格
  ///- gasLimit 最大gas用量
  ///- value 转账数量
  ///- returns 成功返回交易hash
  Future<String?> sendTransaction({
    required Uint8List privateKey,
    required String toAddress,
    required BigInt gasPrice,
    required BigInt gasLimit,
    required BigInt value,
  });

  ///查询交易回执
  ///- txHash 交易哈希
  Future<TransactionReceiptEntity?> getTransactionReceipt(String txHash);

}