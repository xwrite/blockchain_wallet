
///交易回执
class TransactionReceiptEntity {

  ///交易hash
  final String txHash;


  ///实际消耗的 Gas数量
  final BigInt? gasUsed;

  ///区块哈希
  final String blockHash;

  ///区块号
  final int blockNum;

  ///交易状态
  final bool? status;

  TransactionReceiptEntity({
    required this.txHash,
    required this.status,
    this.gasUsed,
    required this.blockHash,
    required this.blockNum,
  });
}
